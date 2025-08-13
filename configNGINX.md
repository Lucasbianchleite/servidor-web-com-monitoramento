# Instalação e Configuração Inicial do Servidor Web (NGINX)

Após concluir a instalação do sistema operacional, vamos dar os primeiros passos para instalar e configurar o servidor web **NGINX**.

---
## 1. Atualizar os Repositórios
Antes de instalar qualquer coisa, é recomendado atualizar os repositórios do sistema:
```bash
sudo apt update
```

---
## 2. Instalar o NGINX
Para instalar o NGINX, usamos:
```bash
sudo apt install nginx -y
```
> O parâmetro `-y` confirma automaticamente a instalação.

Após executar o comando, o sistema inicia o processo de instalação do NGINX.

<img width="1288" height="804" alt="sudo apt install nginx -y" src="https://github.com/user-attachments/assets/f1d28961-84d4-4e66-8dda-e1565730ccc6" />

---
## 3. Iniciar e Ativar o NGINX
Vamos configurar o NGINX para iniciar imediatamente e também iniciar automaticamente junto com o sistema.

Como **root**:
```bash
systemctl start nginx   # Inicia no momento
systemctl enable nginx  # Ativa na inicialização
```

Para verificar o status:
```bash
systemctl status nginx
```
Se aparecer **`active (running)`**, significa que o servidor está ativo.

<img width="1289" height="805" alt="systemctl status nginx" src="https://github.com/user-attachments/assets/d9c9c1cb-9415-4307-82f2-7b1f257b2bb4" />


---
## 4. Testar no Navegador
O próximo passo é abrir um navegador em qualquer dispositivo conectado à mesma rede e acessar o **IP privado** do servidor.

Caso você não saiba qual é o seu IP, execute no terminal:
```bash
ip addr
```
No nosso exemplo, o IP reservado pelo DHCP foi `192.168.15.10`.

Agora, no navegador, digite:
```
http://S.E.U.I.P Ex: http://192.168.15.10
```

<img width="1903" height="993" alt="tela padrão nxinx" src="https://github.com/user-attachments/assets/bd7a406d-2110-4af0-85e0-9a10b04beb76" />



Se a página padrão do **NGINX** for exibida, como mostrado anteriormente, significa que a instalação foi concluída com sucesso.


---

## 5. Configuração do Nginx para servir documento HTML personalizado
:
```bash
sudo apt update
```



[Ver página HTML](index.html)




<img width="1905" height="989" alt="image" src="https://github.com/user-attachments/assets/9828e9ed-c7cc-493d-90a1-79f901c2da0f" />












# Principais Diretórios e Arquivos do NGINX

## 1. `/etc/nginx/` – Configurações Principais
Essa é a pasta mais crítica para administração do NGINX.
- `nginx.conf` — Arquivo principal de configuração.
- `conf.d/` — Arquivos `.conf` adicionais (geralmente configurações globais).
- `sites-available/` — Arquivos de configuração de sites virtuais (*vhosts*).
- `sites-enabled/` — Links simbólicos para os sites ativos.
- `modules-available/` e `modules-enabled/` — Módulos carregáveis (nem todas as distros usam).
- `snippets/` — Arquivos de configuração reutilizáveis.

---
## 2. `/var/www/` – Arquivos dos Sites
- Local padrão para o conteúdo web.
- Exemplo: `/var/www/html` → pasta padrão para páginas HTML.
- Em ambientes com vários sites, cada site pode ter sua própria pasta:
```
/var/www/meusite.com
```

---
## 3. `/var/log/nginx/` – Logs
- `access.log` — Registro de todos os acessos e requisições.
- `error.log` — Registro de erros e mensagens importantes.

> **Dica:** Analisar os logs é essencial para diagnóstico e segurança.

---
## 4. `/var/cache/nginx/` – Cache
- Utilizada se o cache do NGINX estiver habilitado (proxy cache, fastcgi cache, etc.).
- Pode crescer bastante, então é importante monitorar.

---
## 5. `/usr/share/nginx/` – Arquivos Padrão
- Contém páginas padrão (ex.: `index.html` inicial).
- Pode conter templates e arquivos de exemplo.

