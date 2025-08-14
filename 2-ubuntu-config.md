# Configuração do Ubuntu Server em Máquina Virtual

## Introdução
Neste documento, você aprenderá a instalar e configurar o **Ubuntu Server** em uma máquina virtual previamente criada no VirtualBox.  
Este será o sistema operacional base para o projeto **servidor-web-com-monitoramento**.

O passo a passo inclui desde a seleção do idioma e layout do teclado até a configuração de rede, criação de usuário e instalação de pacotes essenciais como o **OpenSSH**.

Com este guia, mesmo usuários sem experiência prévia em servidores Linux poderão configurar o ambiente para a próxima etapa do projeto.

---

## 1. Iniciando a Máquina Virtual
Com o **VirtualBox** aberto, dê **dois cliques** na máquina virtual que você deseja iniciar.  
A VM será carregada e apresentará a tela de configuração inicial.

**Imagem:** tela inicial da VM  

<img width="1913" height="1031" alt="image" src="https://github.com/user-attachments/assets/467b9cd6-62ba-4398-bbc5-51ea3ceac284" />



---

## 2. Seleção de Idioma e Teclado
- Escolha o idioma **Português**.  
- Para a variante de teclado, selecione **Português (Brasil)**, já que o projeto será executado no Brasil.

**Imagem:** seleção de idioma e teclado  

<img width="1277" height="799" alt="image" src="https://github.com/user-attachments/assets/45acf9b4-1ddf-4089-b96a-01e273daff27" />

<img width="1279" height="796" alt="image" src="https://github.com/user-attachments/assets/588c51a1-aa93-416d-8403-b2d19ee524bf" />



---

## 3. Escolhendo a Versão do Ubuntu
Na tela de seleção de instalação:
- Opte por **Ubuntu Server**.

> 💡 Existe também a opção **Ubuntu Server (Minimized)**, que utiliza menos recursos.  
> Como o objetivo do projeto não é otimizar para consumo mínimo, usaremos a versão completa.

**Imagem:** seleção de versão do Ubuntu Server  

<img width="1272" height="868" alt="escolher instalação ubuntu" src="https://github.com/user-attachments/assets/8a9554eb-f59a-457e-bafe-473bf337b1cf" />


---

## 4. Configuração de Rede
Ao iniciar, o servidor receberá um **IP via DHCP** automaticamente.

No exemplo deste projeto, o IP recebido foi **192.168.15.10**.  
Para que esse endereço não mude a cada reinicialização, é possível configurá-lo como **reservado** no roteador.

**Imagem:** tela mostrando IP atribuído pelo DHCP  


<img width="512" height="349" alt="dhcp ip padrão" src="https://github.com/user-attachments/assets/1336e718-aaa2-40e6-9f6b-043013a43401" />



---

## 4.1 (Opcional) Reservando o IP no Roteador
Essa etapa garante que a VM sempre receba o mesmo IP na rede local, facilitando o acesso via **SSH**.

O procedimento varia conforme o modelo do roteador, mas geralmente envolve:
1. Acessar o painel de administração (`192.168.0.1` ou `192.168.1.1`).
2. Localizar as configurações de **DHCP** ou **Reserva de Endereço**.
3. Inserir o **endereço MAC** da interface de rede da VM.
4. Definir o IP fixo desejado (ex.: `192.168.15.10`).
5. Salvar as alterações e reiniciar a conexão.

> ℹ️ Essa configuração é **opcional**, mas altamente recomendada para projetos que necessitam de acesso remoto frequente.

**Imagem:** painel de configuração DHCP do roteador  


<img width="1450" height="869" alt="dhcp vivo" src="https://github.com/user-attachments/assets/cb77455a-40b5-4945-a60e-f2073cbe4251" />

---

## 5. Configurações Adicionais Iniciais
Durante a instalação:
- **Configuração de Proxy** → pular.
- **Seleção de mirror do Ubuntu** → pular.



---

## 6. Local de Instalação
O instalador perguntará onde instalar o sistema:
- Utilize a opção **padrão** de particionamento sugerida pelo Ubuntu Server.



<img width="1604" height="921" alt="image" src="https://github.com/user-attachments/assets/a9a10cce-ce79-4e65-b87d-f6cb20dff733" />

---

## 7. Criação de Usuário
Preencha as seguintes informações:
- Nome completo
- Nome do servidor
- Nome de usuário
- Senha de acesso

> ℹ️ O foco do projeto não é gerenciamento de usuários, então essa etapa será feita de forma simples.

**Imagem:** tela de criação de usuário  
<img width="1848" height="1079" alt="image" src="https://github.com/user-attachments/assets/ee387228-22dc-4ae7-ae0e-f1313aff27a5" />


---

## 8. Instalação de Pacotes Adicionais
O instalador perguntará se deseja instalar o **OpenSSH**:
- Marque **Sim** para habilitar o acesso remoto via SSH.
  <img width="1557" height="1075" alt="image" src="https://github.com/user-attachments/assets/9aee149b-f2a2-41a6-af3d-9c3c5f03377f" />


A lista de pacotes adicionais exibida pode ser ignorada clicando em **Concluído**.

**Imagem:** tela de instalação de pacotes adicionais  
<img width="1468" height="1064" alt="image" src="https://github.com/user-attachments/assets/4e4ab263-6d35-44e7-9be1-711cdbda25e9" />


---

## 9. Conclusão da Instalação
Após confirmar, a instalação do Ubuntu Server será iniciada.  
Quando finalizada, o sistema estará pronto para configuração e uso no projeto.

**Imagem:** tela final de instalação concluída  
<img width="1476" height="1072" alt="image" src="https://github.com/user-attachments/assets/d7374121-486b-437c-81b8-cd5ed4de27f1" />


---

**Nota:** Este documento foi atualizado em **12 de agosto de 2025**.  
As telas e versões exibidas podem variar de acordo com atualizações do Ubuntu.
