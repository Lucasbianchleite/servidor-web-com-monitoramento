#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Execute como root:"
  echo "sudo ./script.sh"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEB_DIR="/var/www/html"
MONITOR_SCRIPT="/usr/local/bin/monitoramento.sh"
ENV_DEST="/etc/monitoramento.env"
LOG_FILE="/var/log/monitoramento.log"
CRON_FILE="/etc/cron.d/monitoramento-nginx"

echo "==> Atualizando sistema..."
apt update && apt upgrade -y

echo "==> Instalando dependências..."
apt install -y nginx curl cron python3

echo "==> Habilitando serviços..."
systemctl enable nginx
systemctl restart nginx
systemctl enable cron
systemctl restart cron

echo "==> Publicando arquivos do site..."
if [ -f "$REPO_DIR/docs/index.html" ]; then
  echo "Arquivos encontrados em $REPO_DIR/docs"
  rm -f "$WEB_DIR/index.nginx-debian.html"
  cp "$REPO_DIR/docs/index.html" "$WEB_DIR/"
  [ -f "$REPO_DIR/docs/style.css" ] && cp "$REPO_DIR/docs/style.css" "$WEB_DIR/"
  [ -f "$REPO_DIR/docs/script.js" ] && cp "$REPO_DIR/docs/script.js" "$WEB_DIR/"
elif [ -f "$REPO_DIR/index.html" ]; then
  echo "Arquivos encontrados em $REPO_DIR"
  rm -f "$WEB_DIR/index.nginx-debian.html"
  cp "$REPO_DIR/index.html" "$WEB_DIR/"
  [ -f "$REPO_DIR/style.css" ] && cp "$REPO_DIR/style.css" "$WEB_DIR/"
  [ -f "$REPO_DIR/script.js" ] && cp "$REPO_DIR/script.js" "$WEB_DIR/"
else
  echo "ERRO: não encontrei index.html nem em docs/ nem na raiz."
  exit 1
fi

echo "==> Criando arquivo de log..."
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

echo "==> Procurando arquivo .env no repositório..."
if [ -f "$REPO_DIR/.env" ]; then
  echo "Arquivo .env encontrado em $REPO_DIR/.env"
  cp "$REPO_DIR/.env" "$ENV_DEST"
elif [ -f "$REPO_DIR/.env.example" ]; then
  echo "Arquivo .env não encontrado. Usando .env.example"
  cp "$REPO_DIR/.env.example" "$ENV_DEST"
else
  echo "ERRO: não encontrei .env nem .env.example na raiz do repositório."
  exit 1
fi

chmod 600 "$ENV_DEST"
echo "Arquivo de ambiente copiado para: $ENV_DEST"

echo "==> Criando script de monitoramento..."
cat > "$MONITOR_SCRIPT" <<'EOF'
#!/bin/bash

ENV_FILE="/etc/monitoramento.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Arquivo de configuração não encontrado: $ENV_FILE"
    exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

if [ -z "$SITE_URL" ] || [ -z "$WEBHOOK_URL" ] || [ -z "$LOG_FILE" ] || [ -z "$SERVICE_NAME" ]; then
    echo "Variáveis obrigatórias ausentes no arquivo $ENV_FILE"
    exit 1
fi

log_only() {
    local DATA
    DATA=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$DATA - $1" >> "$LOG_FILE"
}

send_discord() {
    local msg="$1"
    local payload

    payload=$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps({"content": sys.stdin.read()}))')

    curl -sS -H "Content-Type: application/json" \
         -X POST \
         -d "$payload" \
         "$WEBHOOK_URL" >/dev/null 2>&1
}

log_discord() {
    local DATA
    DATA=$(date '+%Y-%m-%d %H:%M:%S')
    local log_msg="$1"
    local discord_msg="$2"

    echo "$DATA - $log_msg" >> "$LOG_FILE"
    send_discord "$discord_msg"
}

run_healthcheck() {
    curl -s -o /dev/null \
         --connect-timeout "$CONNECT_TIMEOUT" \
         --max-time "$MAX_TIME" \
         -w "%{http_code} %{time_total}" \
         "$SITE_URL"
}

HEALTH_RESULT=$(run_healthcheck)
CURL_EXIT=$?

HTTP_CODE=$(echo "$HEALTH_RESULT" | awk '{print $1}')
RESPONSE_TIME=$(echo "$HEALTH_RESULT" | awk '{print $2}')

[ -z "$HTTP_CODE" ] && HTTP_CODE="000"
[ -z "$RESPONSE_TIME" ] && RESPONSE_TIME="0"

RESPONSE_TIME_FMT=$(printf "%.3f" "$RESPONSE_TIME" 2>/dev/null || echo "0.000")

HEALTHY=true
PROBLEM_REASON=""

if [ "$CURL_EXIT" -ne 0 ]; then
    HEALTHY=false
    PROBLEM_REASON="Falha de conexão ou timeout (curl exit code: $CURL_EXIT)"
elif [ "$HTTP_CODE" -ne 200 ]; then
    HEALTHY=false
    PROBLEM_REASON="Código HTTP inesperado: $HTTP_CODE"
elif awk "BEGIN {exit !($RESPONSE_TIME > $MAX_RESPONSE_TIME)}"; then
    HEALTHY=false
    PROBLEM_REASON="Latência alta: ${RESPONSE_TIME_FMT}s"
fi

if [ "$HEALTHY" = false ]; then
    log_discord \
        "🚨 Healthcheck falhou. Motivo: $PROBLEM_REASON" \
        "🚨 ALERTA CRÍTICO
Servidor: $SITE_URL
Problema: $PROBLEM_REASON
HTTP: $HTTP_CODE
Tempo de resposta: ${RESPONSE_TIME_FMT}s
Ação: tentando reiniciar o serviço $SERVICE_NAME."

    systemctl restart "$SERVICE_NAME"
    sleep 5

    STATUS=$(systemctl is-active "$SERVICE_NAME")

    RECHECK_RESULT=$(run_healthcheck)
    RECHECK_CURL_EXIT=$?
    RECHECK_HTTP_CODE=$(echo "$RECHECK_RESULT" | awk '{print $1}')
    RECHECK_RESPONSE_TIME=$(echo "$RECHECK_RESULT" | awk '{print $2}')

    [ -z "$RECHECK_HTTP_CODE" ] && RECHECK_HTTP_CODE="000"
    [ -z "$RECHECK_RESPONSE_TIME" ] && RECHECK_RESPONSE_TIME="0"

    RECHECK_RESPONSE_TIME_FMT=$(printf "%.3f" "$RECHECK_RESPONSE_TIME" 2>/dev/null || echo "0.000")

    RECOVERED=true
    RECOVERY_REASON=""

    if [ "$STATUS" != "active" ]; then
        RECOVERED=false
        RECOVERY_REASON="Serviço não ficou ativo após restart"
    elif [ "$RECHECK_CURL_EXIT" -ne 0 ]; then
        RECOVERED=false
        RECOVERY_REASON="Site continuou inacessível após restart"
    elif [ "$RECHECK_HTTP_CODE" -ne 200 ]; then
        RECOVERED=false
        RECOVERY_REASON="Site voltou com HTTP $RECHECK_HTTP_CODE"
    elif awk "BEGIN {exit !($RECHECK_RESPONSE_TIME > $MAX_RESPONSE_TIME)}"; then
        RECOVERED=false
        RECOVERY_REASON="Site voltou lento: ${RECHECK_RESPONSE_TIME_FMT}s"
    fi

    if [ "$RECOVERED" = true ]; then
        log_discord \
            "✅ Serviço recuperado com sucesso." \
            "✅ RECUPERAÇÃO BEM-SUCEDIDA
Servidor: $SITE_URL
Serviço: $SERVICE_NAME
Status: $STATUS
HTTP após restart: $RECHECK_HTTP_CODE
Latência após restart: ${RECHECK_RESPONSE_TIME_FMT}s"
    else
        log_discord \
            "❌ Falha na recuperação automática. Motivo: $RECOVERY_REASON" \
            "❌ FALHA NA RECUPERAÇÃO
Servidor: $SITE_URL
Serviço: $SERVICE_NAME
Status: $STATUS
Motivo: $RECOVERY_REASON
HTTP após restart: $RECHECK_HTTP_CODE
Latência após restart: ${RECHECK_RESPONSE_TIME_FMT}s
Necessária intervenção manual."
    fi
else
    log_only "Healthcheck OK | HTTP: $HTTP_CODE | Tempo: ${RESPONSE_TIME_FMT}s"
fi
EOF

chmod +x "$MONITOR_SCRIPT"

echo "==> Criando cron..."
cat > "$CRON_FILE" <<EOF
*/1 * * * * root $MONITOR_SCRIPT
EOF

chmod 644 "$CRON_FILE"
systemctl restart cron

echo
echo "========================================"
echo "INSTALAÇÃO FINALIZADA"
echo "========================================"
echo "Arquivo de ambiente usado: $ENV_DEST"
echo "Monitoramento criado em: $MONITOR_SCRIPT"
echo "Cron criado em: $CRON_FILE"
echo "Log em: $LOG_FILE"
echo
echo "Revise o arquivo de ambiente:"
echo "nano $ENV_DEST"
echo
echo "Teste manual:"
echo "$MONITOR_SCRIPT"
