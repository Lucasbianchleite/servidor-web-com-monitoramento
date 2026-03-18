#!/bin/bash
set -e

# =========================
# CONFIGURAÇÕES
# =========================
REPO_URL="https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git"
BRANCH="main"
APP_DIR="/opt/meu-projeto-web"
WEB_ROOT="/var/www/html"

SITE_URL="http://192.168.15.10"
WEBHOOK_URL="https://discord.com/api/webhooks/SEU_WEBHOOK_AQUI"

MONITOR_SCRIPT="/usr/local/bin/monitoramento.sh"
LOG_FILE="/var/log/monitoramento.log"
CRON_FILE="/etc/cron.d/monitoramento-nginx"

# =========================
# VERIFICA ROOT
# =========================
if [ "$EUID" -ne 0 ]; then
  echo "Execute como root: sudo bash setup_projeto.sh"
  exit 1
fi

echo "[1/8] Atualizando repositórios..."
apt update
apt install -y nginx git curl cron rsync

echo "[2/8] Ativando serviços..."
systemctl enable nginx
systemctl start nginx
systemctl enable cron
systemctl start cron

echo "[3/8] Clonando ou atualizando projeto..."
if [ -d "$APP_DIR" ]; then
  cd "$APP_DIR"
  git fetch origin
  git reset --hard "origin/$BRANCH"
else
  git clone -b "$BRANCH" "$REPO_URL" "$APP_DIR"
fi

echo "[4/8] Publicando arquivos no NGINX..."
rm -rf "${WEB_ROOT:?}/"*
rsync -av --exclude=".git" "$APP_DIR"/ "$WEB_ROOT"/

chown -R www-data:www-data "$WEB_ROOT"
find "$WEB_ROOT" -type d -exec chmod 755 {} \;
find "$WEB_ROOT" -type f -exec chmod 644 {} \;

echo "[5/8] Criando log..."
touch "$LOG_FILE"
chown root:adm "$LOG_FILE"
chmod 664 "$LOG_FILE"

echo "[6/8] Criando script de monitoramento..."
cat > "$MONITOR_SCRIPT" <<EOF
#!/bin/bash

SITE_URL="$SITE_URL"
WEBHOOK_URL="$WEBHOOK_URL"
LOG_FILE="$LOG_FILE"
DATE_NOW=\$(date '+%Y-%m-%d %H:%M:%S')

logar() {
  echo "[\$DATE_NOW] \$1" >> "\$LOG_FILE"
}

webhook() {
  local MSG="\$1"
  curl -s -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\":\"\$MSG\"}" \
       "\$WEBHOOK_URL" >/dev/null 2>&1
}

HTTP_CODE=\$(curl -L -s -o /dev/null -w "%{http_code}" --max-time 10 "\$SITE_URL" || echo "000")

if systemctl is-active --quiet nginx && [ "\$HTTP_CODE" = "200" ]; then
  logar "OK - Nginx ativo e site respondendo HTTP \$HTTP_CODE."
else
  logar "FALHA - Nginx inativo ou site respondeu HTTP \$HTTP_CODE. Reiniciando..."
  systemctl restart nginx
  sleep 3

  NOVO_HTTP_CODE=\$(curl -L -s -o /dev/null -w "%{http_code}" --max-time 10 "\$SITE_URL" || echo "000")

  if systemctl is-active --quiet nginx && [ "\$NOVO_HTTP_CODE" = "200" ]; then
    logar "RECUPERADO - Nginx reiniciado com sucesso. HTTP \$NOVO_HTTP_CODE."
    webhook "⚠️ Alerta: o Nginx caiu, mas foi reiniciado com sucesso. Status atual: HTTP \$NOVO_HTTP_CODE. URL: \$SITE_URL"
  else
    logar "ERRO - Falha ao recuperar Nginx. HTTP após reinício: \$NOVO_HTTP_CODE."
    webhook "🚨 Crítico: falha no servidor web. Reinício não resolveu. Status atual: HTTP \$NOVO_HTTP_CODE. URL: \$SITE_URL"
  fi
fi
EOF

chmod +x "$MONITOR_SCRIPT"

echo "[7/8] Configurando cron..."
cat > "$CRON_FILE" <<EOF
* * * * * root $MONITOR_SCRIPT
EOF
chmod 644 "$CRON_FILE"

echo "[8/8] Testando NGINX..."
nginx -t
systemctl restart nginx
systemctl restart cron

echo
echo "=================================="
echo "CONFIGURAÇÃO FINALIZADA"
echo "=================================="
echo "Projeto clonado em: $APP_DIR"
echo "Site publicado em:  $WEB_ROOT"
echo "Monitoramento:      $MONITOR_SCRIPT"
echo "Log:                $LOG_FILE"
echo "Cron:               $CRON_FILE"
echo "Acesse:             $SITE_URL"
