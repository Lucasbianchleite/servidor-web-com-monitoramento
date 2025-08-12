# Configuração do Ubuntu

Terminado a instalação e configuração da máquina virtual, vamos para a instalação do sistema operacional.

## 1. Iniciando a máquina virtual
Com o VirtualBox aberto, clique **duas vezes** na máquina que você deseja iniciar.  
A máquina virtual irá subir e aparecerá uma tela pedindo para você preencher as configurações iniciais, como mostra a imagem abaixo.

## 2. Idioma e teclado
Após iniciado a VM, o Linux pergunta qual idioma vamos usar no servidor.  
Vamos escolher **Português** e, em seguida, ele vai perguntar qual a variante do teclado.  
Como o projeto está sendo feito no Brasil, escolhemos **Portuguese (Brasil)**.

## 3. Escolha da versão do Ubuntu
Em seguida, escolhemos a opção de instalar o **Ubuntu Server**, já que a opção **Ubuntu Server (Minimized)** é mais leve e esse não é o intuito do projeto.

## 4. Configuração de rede
Em seguida, vemos que o DHCP entregou um IP para a máquina.  
Para que o IP privado dessa máquina não fique mudando, irei nas configurações de **DHCP do meu roteador** para reservar o IP `192.168.15.10`.  
Lembrando que essa parte é **opcional** e não precisa ser feita — irei fazer apenas para que o IP não fique mudando ao reiniciar a máquina e que seja mais fácil caso tenha que conectar via SSH.

Como a foto acima mostra, o IP do servidor foi reservado com o IP `192.168.15.10`.

## 4.1 (Opcional) Reservando o IP no roteador
A reserva de IP garante que o servidor sempre receba o mesmo endereço na rede local.  
Esse processo varia de acordo com o modelo do roteador, mas normalmente envolve:

1. Acessar o **painel administrativo** do roteador pelo navegador (`192.168.0.1`, `192.168.1.1` ou outro endereço).
2. Localizar a seção de **Configurações DHCP** ou **Reserva de Endereço**.
3. Informar o **endereço MAC** da interface de rede da máquina virtual.
4. Atribuir o IP desejado (no caso, `192.168.15.10`).
5. Salvar as alterações e reiniciar a conexão.

> 💡 Essa etapa não é obrigatória, mas ajuda a manter o IP fixo para facilitar o acesso remoto via SSH.

## 5. Configurações adicionais iniciais
Em seguida, existem etapas como:
- Configurar um **Proxy** → pular.
- Procurar um **mirror** do Ubuntu → pular.

## 6. Local de instalação
O Linux perguntará onde deve ser instalado.  
Como o foco não é fazer as partições do zero, vamos escolher a **padrão** que vem no Ubuntu Server.

## 7. Criação de usuário
Você preencherá dados como:
- Seu nome
- Nome do servidor
- Nome de usuário
- Palavra-chave

Como o foco do projeto não é a criação de usuários, essa etapa será passada **bem por cima**.

## 8. Instalação de pacotes adicionais
Após a configuração do usuário, será perguntado se é necessário instalar o **OpenSSH**.  
Como a minha intenção é acessar via SSH (*Secure Shell*), vou habilitar.  

Além do SSH, o Ubuntu mostra uma série de opções de aplicações para instalar.  
Como não será usada nenhuma das que ele lista, apenas clicamos em **Concluído**.

## 9. Conclusão da instalação
Após clicar em **Concluído**, será iniciada a instalação do Ubuntu.
