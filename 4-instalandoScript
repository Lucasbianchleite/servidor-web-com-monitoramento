# Etapa 4: Configuração do Script de Verificação (.sh)

Nesta etapa, vamos implementar um **script Bash de monitoramento ativo**, responsável por:

- Realizar **checagem periódica de disponibilidade HTTP** do servidor web.
- Registrar logs de execução detalhados em `/var/log/monitoramento.log`, incluindo **timestamps** e códigos de resposta HTTP.
- Detectar falhas no serviço Nginx e **executar reinício automático** via `systemctl`.
- Integrar com serviços externos via **webhook do Discord**, enviando alertas estruturados com informações de status do servidor.
- Garantir execução contínua quando agendado via **cron** ou **systemd timer**, permitindo monitoramento em tempo real sem intervenção manual.

### 1. Instalando o script

No terminal do servidor, crie o arquivo do script:

```bash
sudo nano /usr/local/bin/monitoramento.sh
```
