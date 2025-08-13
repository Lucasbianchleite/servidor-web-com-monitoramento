#!/bin/bash
# Define que o script será executado pelo interpretador Bash

# ==============================
# CONFIGURAÇÕES
# ==============================
SITE_URL="http://192.168.15.10"  
# Endereço do site/servidor que será monitorado

WEBHOOK_URL="https://discord.com/api/webhooks/1403424219403915344/looPMmd9kLnZ0ss6l0vTwYREtyt11Esl5_4Z4lx9Zp2MBBeXazPHiLit1BjIUeXVxmSs"
# URL do webhook do Discord que receberá alertas

LOG_FILE="/var/log/monitoramento.log"
# Caminho do arquivo de log local onde o script vai registrar eventos

DATA=$(date '+%Y-%m-%d %H:%M:%S')
# Variável que armazena a data/hora atual para incluir nos logs

# ==============================
# FUNÇÃO ÚNICA PARA LOG + DISCORD
# ==============================
log_discord() {
    local log_msg="$1"       # Mensagem que será registrada no arquivo de log
    local discord_msg="$2"   # Mensagem que será enviada para o Discord

    echo "$DATA - $log_msg" >> "$LOG_FILE"
    # Adiciona a mensagem no arquivo de log junto com a data/hora

    curl -s -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"$discord_msg\"}" \
         "$WEBHOOK_URL" >/dev/null
    # Envia a mensagem para o webhook do Discord
    # -s: modo silencioso (não mostra saída)
    # >/dev/null: ignora saída do curl
}

# ==============================
# VERIFICAÇÃO DO SITE
# ==============================
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL")
# Faz uma requisição HTTP ao site
# -s: silencioso
# -o /dev/null: descarta o conteúdo da resposta
# -w "%{http_code}": captura apenas o código HTTP retornado (200, 404, etc.)

if [ "$HTTP_CODE" -ne 200 ]; then
    # Se o código HTTP não for 200 (ou seja, site indisponível)

    log_discord "🚨 Site OFFLINE! Código HTTP: $HTTP_CODE" \
                "🚨 **ALERTA CRÍTICO!**\n🛑 O servidor **$SITE_URL** não está respondendo!\n📅 **Data/Hora:** $DATA\n📡 **Código HTTP:** \`$HTTP_CODE\`\n⚡ Tentando recuperação automática..."
    # Registra no log e envia mensagem de alerta ao Discord

    sudo systemctl start nginx
    # Tenta iniciar/reiniciar o serviço Nginx

    sleep 3
    # Aguarda 3 segundos para o serviço iniciar

    STATUS=$(systemctl is-active nginx)
    # Verifica o status atual do Nginx
    # Retorna "active" se estiver rodando, outro valor se não

    if [ "$STATUS" == "active" ]; then
        log_discord "✅ Nginx reiniciado com sucesso." \
                    "✅ **Recuperação bem-sucedida!**\n💻 O serviço **Nginx** foi reiniciado e o site deve estar **ONLINE** novamente.\n📅 **Data/Hora:** $DATA\n🚀 Status atual: \`$STATUS\`"
        # Se voltou a funcionar, envia alerta positivo
    else
        log_discord "❌ Falha ao reiniciar o Nginx." \
                    "❌ **Falha grave!**\n⚠️ O script tentou reiniciar o **Nginx**, mas não obteve sucesso.\n📅 **Data/Hora:** $DATA\n💡 **Ação necessária:** Intervenção manual imediata."
        # Se não voltou, envia alerta de falha
    fi

else
    echo "$DATA - 🟢 Site online. Código HTTP: $HTTP_CODE" >> "$LOG_FILE"
    # Se o site está online (HTTP 200), registra apenas no log
fi

