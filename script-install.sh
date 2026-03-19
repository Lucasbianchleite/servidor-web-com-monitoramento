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
LOG_FILE="/var/log/monitoramento.log"
CRON_FILE="/etc/cron.d/monitoramento-nginx"

echo "==> Atualizando pacotes..."
apt update && apt upgrade -y

echo "==> Instalando Nginx e dependências..."
apt install -y nginx curl cron

echo "==> Habilitando serviços no boot..."
systemctl enable nginx
systemctl restart nginx
systemctl enable cron
systemctl restart cron

echo "==> Procurando arquivos do site..."

if [ -f "$REPO_DIR/docs/index.html" ]; then
  echo "Arquivos encontrados em: $REPO_DIR/docs"
  rm -f "$WEB_DIR/index.nginx-debian.html"
  cp "$REPO_DIR/docs/index.html" "$WEB_DIR/"
  [ -f "$REPO_DIR/docs/style.css" ] && cp "$REPO_DIR/docs/style.css" "$WEB_DIR/"
  [ -f "$REPO_DIR/docs/script.js" ] && cp "$REPO_DIR/docs/script.js" "$WEB_DIR/"

elif [ -f "$REPO_DIR/index.html" ]; then
  echo "Arquivos encontrados em: $REPO_DIR"
  rm -f "$WEB_DIR/index.nginx-debian.html"
  cp "$REPO_DIR/index.html" "$WEB_DIR/"
  [ -f "$REPO_DIR/style.css" ] && cp "$REPO_DIR/style.css" "$WEB_DIR/"
  [ -f "$REPO_DIR/script.js" ] && cp "$REPO_DIR/script.js" "$WEB_DIR/"

else
  echo "ERRO: não encontrei index.html nem em $REPO_DIR/docs nem em $REPO_DIR"
  exit 1
fi

echo "==> Criando arquivo de log..."
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

echo "==> Criando script de monitoramento..."
cat > "$MONITOR_SCRIPT" <<'EOF'
#!/bin/bash

SITE_URL="http://127.0.0.1"
WEBHOOK_URL="COLE_AQUI_O_NOVO_WEBHOOK_DO_DISCORD"
LOG_FILE="/var/log/monitoramento.log"

log_discord() {
    local DATA
    DATA=$(date '+%Y-%m-%d %H:%M:%S')

    local log_msg="$1"
    local discord_msg="$2"

    echo "$DATA - $log_msg" >> "$LOG_FILE"

    curl -s -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"$discord_msg\"}" \
         "$WEBHOOK_URL" >/dev/null 2>&1
}

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL")

if [ "$HTTP_CODE" -ne 200 ]; then
    log_discord "🚨 Site OFFLINE! Código HTTP: $HTTP_CODE" \
                "🚨 **ALERTA CRÍTICO!**\n🛑 O servidor **$SITE_URL** não está respondendo!\n📡 **Código HTTP:** \`$HTTP_CODE\`\n⚡ Tentando recuperação automática..."

    systemctl restart nginx
    sleep 3

    STATUS=$(systemctl is-active nginx)

    if [ "$STATUS" = "active" ]; then
        log_discord "✅ Nginx reiniciado com sucesso." \
                    "✅ **Recuperação bem-sucedida!**\n💻 O serviço **Nginx** foi reiniciado e o site deve estar **ONLINE** novamente.\n🚀 Status atual: \`$STATUS\`"
    else
        log_discord "❌ Falha ao reiniciar o Nginx." \
                    "❌ **Falha grave!**\n⚠️ O script tentou reiniciar o **Nginx**, mas não obteve sucesso.\n💡 **Ação necessária:** Intervenção manual imediata."
    fi
else
    DATA=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$DATA - 🟢 Site online. Código HTTP: $HTTP_CODE" >> "$LOG_FILE"
fi
EOF

chmod +x "$MONITOR_SCRIPT"

echo "==> Criando agendamento no cron..."
cat > "$CRON_FILE" <<EOF
*/1 * * * * root $MONITOR_SCRIPT
EOF

chmod 644 "$CRON_FILE"

echo "==> Recarregando cron..."
systemctl restart cron

echo
echo "========================================"
echo "INSTALAÇÃO FINALIZADA"
echo "========================================"
echo "Nginx habilitado no boot: OK"
echo "Cron habilitado no boot: OK"
echo "Monitoramento agendado a cada 1 minuto: OK"
echo
echo "Arquivos do site em: $WEB_DIR"
echo "Script de monitoramento em: $MONITOR_SCRIPT"
echo "Agendamento cron em: $CRON_FILE"
echo "Log em: $LOG_FILE"
echo
echo "IMPORTANTE:"
echo "Edite as variáveis antes de confiar no monitoramento:"
echo "nano $MONITOR_SCRIPT"
echo
echo "Corrija:"
echo "- SITE_URL"
echo "- WEBHOOK_URL"
echo
echo "Teste manualmente também:"
echo "$MONITOR_SCRIPT"
