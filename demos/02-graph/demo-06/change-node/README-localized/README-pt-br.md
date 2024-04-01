---
page_type: sample 
products:
- ms-graph
languages:
- nodejs
- javascript
description: "Criar assinaturas de webhook do Microsoft Graph para o aplicativo Node.js., para que ele possa receber notificações de alterações nos dados da conta da Microsoft de um usuário."
extensions:
  contentType: samples
  technologies:
  - Microsoft Graph
  createdDate: 3/9/2016 4:12:18 PM
---
# Exemplo de webhooks do Microsoft Graph para Node.js

[![Status da compilação](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample.svg)](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample)

## Sumário ##
* [Introdução](#introduction)

* [Capturas de tela](#screenshots)

* [Pré-requisitos](#prerequisites)

* [Registrar o aplicativo](#Register-the-app)

* [Configurar um túnel para seu localhost](#Configure-a-tunnel-for-your-localhost)

* [Configurar e executar o aplicativo](#Configure-and-run-the-web-app)

* [Colaboração](#contributing)

* [Perguntas e comentários](#Questions-and-Comments)

* [Recursos adicionais](#Additional-resources)


## Introdução
<a name="introduction"></a>

Esse exemplo do Node.js mostra como começar a receber notificações do Microsoft Graph. A seguir, são apresentadas tarefas comuns que um aplicativo da Web executa com assinaturas dos webhooks do Microsoft Graph.

- Faça login nos usuários com a conta corporativa ou escolar para obter um token de acesso.
- Use o token de acesso para criar uma assinatura para um webhook.
- Devolva um token de validação para confirmar a URL de notificação.
- Ouça as notificações do Microsoft Graph.
- Solicitação para obter mais informações sobre o Microsoft Office 365 usando dados na notificação.

## Capturas de tela
<a name="screenshots"></a>

1. Primeiro, você precisa entrar.

    ![entrar](https://user-images.githubusercontent.com/3375461/31968683-c373ad30-b8c6-11e7-9d01-413fab9fd6d5.png)

1. Depois de entrar, o aplicativo ouvirá os e-mails de entrada.

    ![ouvir](https://user-images.githubusercontent.com/3375461/31968718-e19696c4-b8c6-11e7-91f2-f1806be0b134.png)

1. Depois de enviar o e-mail ao endereço, você visualizará o e-mail no aplicativo.

    ![e-mail](https://user-images.githubusercontent.com/3375461/31968754-0ce4dafc-b8c7-11e7-8458-8152d598228e.png)

## Pré-requisitos
<a name="prerequisites"></a>

Para usar este webhook, você precisa do seguinte:

- [Node.js](https://nodejs.org/) versão 4 ou 5.
- Uma [conta corporativa ou de estudante](http://dev.office.com/devprogram).

## Registrar o aplicativo
<a name="Register-the-app"></a>

Esse aplicativo utiliza o terminal do Azure AD para registrá-lo no [portal do Azure](https://ms.portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade).

1. Entrar no portal do Azure utilizando uma conta corporativa, de estudante ou pessoal da Microsoft.
1. Se sua conta permitir o acesso a mais de um locatário, clique na sua conta no canto superior direito e configure sua sessão do portal ao locatário do Azure AD desejado (utilizando o Diretório de alternadores).
1. No painel de navegação à esquerda, clique no serviço **serviços do Diretório ativo do Azure**, e depois clique em **Registros do aplicativo**
![](readme-images/registrations.png).

1. Clique em **Novo registro do aplicativo**.

    1. Digite um nome amigável ao aplicativo.
    1. Clique em Aplicativo Web/API como o **Tipo de Aplicativo**.
    1. Digite `http://localhost:3000/callback` para a **URL de entrada**.
    1. Na seção Tipos de conta com suporte, clique em Contas em qualquer diretório organizacional e contas pessoais do Microsoft (por exemplo: Skype, Xbox, Outlook.com).
    1. Clique em **Criar**.

1. Escolha seu novo aplicativo na lista de aplicativos registrados.Na página **Visão geral** do aplicativo, encontre o valor da **ID do aplicativo (cliente)** e registre-o para usar mais tarde.
Será necessário que você configure o arquivo de configuração do Visual Studio para este projeto.
![](readme-images/client.png)
1. Configure permissões para o seu aplicativo:

    1. Clique em **Configurações** > **Permissões necessárias** > **Add**.
    1. Clique em **Selecione uma API** > **Microsoft Graph**e clique em **Selecionar**.
    1. Clique em **Selecionar permissões**, role para baixo até **Permissões delegadas**, clique em **Leitura do correio** e, em seguida, clique em **Selecionar**.
    1. Clique em ****concluído.
	![](readme-images/permissions.png)

1. Clique em **Certificados e segredos** em **Gerenciar**. Clique com o botão em **Novo segredo do cliente**. Insira um valor em Descrição e clique em uma das opções de Expira e cliquem em **Adicionar**.

![](readme-images/secrets.png)

1. **Importante**: Copie o valor chave--esse é o segredo do seu aplicativo. Você não conseguirá acessar esse valor novamente depois de sair desse painel.

Você usará a **ID do aplicativo** e **de segredo** para configurar o aplicativo.

## Configurar um túnel para seu localhost

O exemplo utiliza localhosts como o servidor de desenvolvimento. Por essa razão, precisamos de um encapsulamento que poderá encaminhar solicitações de uma URL na Internet ao seu localhost. Se, por alguma razão, você não quiser usar um encapsulamento, consulte [Hospedagem sem um encapsulamento](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Hosting-the-sample-without-a-tunnel). Se quiser obter uma explicação detalhada de como usar um encapsulamento, consulte [Por que preciso usar um encapsulamento?](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Why-do-I-have-to-use-a-tunnel)

Neste exemplo, usamos [ngrok](https://ngrok.com/) para criar o encapsulamento. Para configurar o ngrok:

1. [Baixar](https://ngrok.com/download) e descompactar os binários ngrok da sua plataforma.
1. Digite o seguinte comando:

    ```Shell
    ngrok http 3000
    ```

1. Anote a * URL pública https*que o ngrok fornece a você. Isto é um exemplo:

    ```http
    https://{NGROK_ID}.ngrok.io
    ```

Você precisará do valor `NGROK_ID` nas próximas seções.

## Configure e execute o aplicativo da Web

1. Use um editor de texto para abrir `constants.js`.
1. Substitua `ENTER_YOUR_CLIENT_ID` pela ID do cliente do aplicativo Azure registrado.
1. Substitua `ENTER_YOUR_SECRET` pelo segredo do cliente do aplicativo Azure registrado.
1. Substitua `NGROK_ID` pelo valor na *URL pública https* da seção anterior.
![](const)
1. Instale as dependências executando o seguinte comando:

    ```Shell
    npm install
    ```

1. Inicie o aplicativo com o seguinte comando:

    ```Shell
    npm start
    ```
    > **Observação:** Você também pode fazer com que o aplicativo aguarde por um depurador. Para esperar por um depurador, use o seguinte comando:
    >
    > ```Shell
    > npm run debug
    > ```
    > Você também pode anexar o depurador incluído no código do Microsoft Visual Studio. Para obter mais informações, consulte Depurador no Visual Studio Code[](https://code.visualstudio.com/Docs/editor/debugging).

1. Abra um navegador e vá para [http://localhost:3000](http://localhost:3000).

## Colaboração

Se quiser contribuir para esse exemplo, confira [CONTRIBUTING.MD](/CONTRIBUTING.md).

Este projeto adotou o [Código de Conduta de Código Aberto da Microsoft](https://opensource.microsoft.com/codeofconduct/).  Para saber mais, confira as [Perguntas frequentes sobre o Código de Conduta](https://opensource.microsoft.com/codeofconduct/faq/) ou entre em contato pelo [opencode@microsoft.com](mailto:opencode@microsoft.com) se tiver outras dúvidas ou comentários.

## Perguntas e comentários

Gostaríamos de receber seus comentários sobre o exemplo Microsoft Graph Webhook. Você pode enviar perguntas e sugestões na seção [Problemas](https://github.com/OfficeDev/Microsoft-Graph-NodeJs-Webhooks/issues) deste repositório.

Perguntas de desenvolvimento do Office 365? Poste-as em [Excedente](http://stackoverflow.com/questions/tagged/Office365+API). Certifique-se de marcar suas perguntas ou comentários com \[Office365] e \[API].

## Recursos adicionais

- [Visão geral do Microsoft Graph](http://graph.microsoft.io/)
- [Documentação de referência da assinatura](https://graph.microsoft.io/en-us/docs/api-reference/beta/resources/subscription)

## Direitos autorais

Copyright (c) 2019 Microsoft. Todos os direitos reservados.
