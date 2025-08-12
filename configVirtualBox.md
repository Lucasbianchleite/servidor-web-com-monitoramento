# Configuração do VirtualBox para o Servidor Ubuntu

## Introdução

Neste documento, você aprenderá a configurar uma máquina virtual no VirtualBox para rodar o Ubuntu Server, que será a base do projeto **servidor-web-com-monitoramento**. 

Vamos cobrir desde a escolha da distribuição Linux, criação da máquina virtual, configuração de hardware (memória, CPU, rede) até a preparação para a instalação manual do sistema operacional.

Com este passo a passo, mesmo quem nunca usou VirtualBox poderá acompanhar e deixar o ambiente pronto para receber o servidor web com monitoramento automatizado.

---

## 1. Escolha da Distribuição Linux

O projeto utiliza o **Ubuntu Server 24.04.3 LTS**, uma versão estável e adequada para servidores. Você pode baixar a ISO diretamente no site oficial:

[Download Ubuntu Server 24.04.3 LTS](https://ubuntu.com/download/server)

*Imagem: página de download do Ubuntu Server*  
`![Download Ubuntu Server](imagens/ubuntu-server-download.png)`

---

## 2. Baixando o VirtualBox

Para criar e gerenciar a máquina virtual onde o Ubuntu Server será instalado, usaremos o VirtualBox.

Baixe a versão mais recente (por exemplo, VirtualBox 7.1.12) no site oficial:  

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

*Imagem: página de download do VirtualBox*  
`![Download VirtualBox](imagens/virtualbox-download.png)`

---

## 3. Criando a Máquina Virtual

Após instalar o VirtualBox, siga os passos para criar sua máquina virtual:

1. Clique em **Novo** para iniciar a criação da VM.

2. Preencha o formulário de criação conforme mostrado na imagem abaixo:

   - **Nome do Servidor:** `SERVIDOR-WEB-PROJETO1`  
   - **Pasta de Armazenamento:** selecione onde a VM será salva.  
   - **Imagem ISO:** selecione o arquivo ISO do Ubuntu Server baixado anteriormente.  
   - **Detalhes da Máquina:** o VirtualBox preencherá automaticamente o tipo, subtipo e versão do sistema operacional.  
   - **Pular instalação desassistida:** marque essa opção para que a instalação seja manual e completa, permitindo controle total durante o processo.

3. Após preencher, clique em **Finalizar**.

*Imagem: formulário de criação da VM no VirtualBox*  
`![Formulário criação VM](imagens/virtualbox-formulario-vm.png)`

---

## 4. Configuração de Hardware da Máquina Virtual

Agora, configure a memória RAM, CPU e rede da sua VM para garantir desempenho e conectividade adequados.

1. Clique com o botão direito na VM criada e selecione **Configurações**.

2. Na aba **Sistema > Memória**, ajuste a memória base disponível para a VM (exemplo: 2048 MB).

*Imagem: configuração de memória RAM*  
`![Configuração Memória](imagens/virtualbox-memoria.png)`

3. Na aba **Sistema > Processador**, defina o número de núcleos que o servidor poderá usar.

*Imagem: configuração do processador*  
`![Configuração CPU](imagens/virtualbox-cpu.png)`

4. Na aba **Rede > Adaptador 1**, configure o modo como **Bridge (Bridged Adapter)** para que a VM tenha acesso à rede local e receba um IP do DHCP.

*Imagem: configuração de rede*  
`![Configuração Rede](imagens/virtualbox-rede.png)`

---

## 5. Próximos Passos

Com a VM criada e configurada, você estará pronto para iniciar a instalação manual do Ubuntu Server e dar sequência à configuração do servidor web com monitoramento.

---

