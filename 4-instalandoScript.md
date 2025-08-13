# Etapa 4: Configuração do Script de Verificação e testando (.sh)

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

Cole o conteúdo do script de monitoramento: [script](monitoramento.sh)
Após colar, salve o arquivo pressionando CTRL + O, confirme com Enter e saia do nano com CTRL + X

<img width="1919" height="989" alt="image" src="https://github.com/user-attachments/assets/897f12c3-9650-4cd7-819d-4436c49c5fc2" />

### 2. permissão de execução ao script:

Em seguida, dê permissão de execução ao script:
```bash
sudo chmod +x /usr/local/bin/monitoramento.sh
```

Isso garante que o script possa ser executado diretamente como um programa.

### 3. Testando o Script
ara verificar se tudo está funcionando corretamente, execute:

```bash
sudo /usr/local/bin/monitoramento.sh
```
Como o Nginx provavelmente já está ativo, o script de monitoramento não exibirá nenhuma ação no teste. Para validar se o script reinicia corretamente o serviço e envia alertas, podemos parar temporariamente o Nginx:
```bash
systemctl stop nginx
```
novamente rodamos o script, e vemos que  chegou um alerta do webhook no discord
```bash
sudo /usr/local/bin/monitoramento.sh
```


<img width="1920" height="992" alt="teste do script" src="https://github.com/user-attachments/assets/d2f34050-d3e7-427a-b713-cbd63fdce8c6" />
Com este teste de queda controlada do Nginx, ao executar o script de monitoramento, o webhook foi acionado automaticamente, registrando e notificando que o serviço estava inativo e confirmando que o servidor foi reiniciado com sucesso.

### Isso demonstra que o script:

- Detecta falhas no serviço web em tempo real;

- Executa a ação de recuperação automaticamente (restart do Nginx);

- Envia notificações para o canal configurado via webhook, garantindo visibilidade imediata do incidente.
