# Configuração do VirtualBox para o Servidor Ubuntu

## Introdução

Neste documento, você aprenderá a configurar uma máquina virtual no VirtualBox para rodar o Ubuntu Server, que será a base do projeto **servidor-web-com-monitoramento**. 

Vamos cobrir desde a escolha da distribuição Linux, criação da máquina virtual, configuração de hardware (memória, CPU, rede) até a preparação para a instalação manual do sistema operacional.

Com este passo a passo, mesmo quem nunca usou VirtualBox poderá acompanhar e deixar o ambiente pronto para receber o servidor web com monitoramento automatizado.

---

## 1. Escolha da Distribuição Linux

O projeto utiliza o **Ubuntu Server 24.04.3 LTS**, uma versão estável e adequada para servidores. Você pode baixar a ISO diretamente no site oficial:

[Download Ubuntu Server 24.04.3 LTS](https://ubuntu.com/download/server)
> **Nota:** A versão do Ubuntu Server pode variar dependendo da data de acesso.  
> Este documento foi atualizado em 12 de agosto de 2025.  
> Sempre verifique o site oficial para a versão mais recente disponível.

*Imagem: página de download do Ubuntu Server*  
<img width="1915" height="985" alt="image" src="https://github.com/user-attachments/assets/45cddea3-ccdc-439b-a84f-b06a0f311d20" />


---

## 2. Baixando o VirtualBox

Para criar e gerenciar a máquina virtual onde o Ubuntu Server será instalado, usaremos o VirtualBox.

Baixe a versão mais recente (por exemplo, VirtualBox 7.1.12) no site oficial:  

[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)
> **Nota:** A versão do VirtualBox pode variar dependendo da data de acesso.  
> Este documento foi atualizado em 12 de agosto de 2025.  
> Sempre verifique o site oficial para a versão mais recente disponível.

*Imagem: página de download do VirtualBox*  
<img width="1907" height="971" alt="image" src="https://github.com/user-attachments/assets/da63bb6e-6ef6-4a9a-a8a3-6fb879fae8ff" />



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

