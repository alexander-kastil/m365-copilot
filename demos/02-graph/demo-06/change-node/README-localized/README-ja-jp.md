---
page_type: sample 
products:
- ms-graph
languages:
- nodejs
- javascript
description: "Node.js アプリ用の Microsoft Graph Webhook サブスクリプションを作成し、ユーザーの Microsoft アカウント データに関する変更通知を受け取れるようにできます。"
extensions:
  contentType: samples
  technologies:
  - Microsoft Graph
  createdDate: 3/9/2016 4:12:18 PM
---
# Node.js 用 Microsoft Graph Webhooks サンプル

[![ビルドの状態](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample.svg)](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample)

## 目次 ##
* [概要](#introduction)

* [スクリーンショット](#screenshots)

* [前提条件](#prerequisites)

* [アプリを登録する](#Register-the-app)

* [localhost のトンネルを構成する](#Configure-a-tunnel-for-your-localhost)

* [Web アプリの構成して実行する](#Configure-and-run-the-web-app)

* [投稿](#contributing)

* [質問とコメント](#Questions-and-Comments)

* [その他の技術情報](#Additional-resources)


## 概要
<a name="introduction"></a>

この Node.js サンプルでは、Microsoft Graph からの通知の取得を開始する方法を示します。Web アプリケーションが Microsoft Graph Webhooks を使用して実行する一般的なタスクを次に示します。

- ユーザーを職場または学校のアカウントでサインインさせて、アクセス トークンを取得させます。
- アクセス トークンを使用して、Webhook サブスクリプションを作成します。
- 検証トークンを送り返して通知 URL を確認します。
- Microsoft Graph からの通知をリッスンします。
- 通知のデータを使用して、Microsoft Office 365 で詳細情報を要求します。

## スクリーンショット
<a name="screenshots"></a>

1. まずサインインが必要です。

    ![署名](https://user-images.githubusercontent.com/3375461/31968683-c373ad30-b8c6-11e7-9d01-413fab9fd6d5.png)

1. サインインすると、アプリは受信メールをリッスンします。

    ![リスニング](https://user-images.githubusercontent.com/3375461/31968718-e19696c4-b8c6-11e7-91f2-f1806be0b134.png)

1. アドレスにメールを送信すると、アプリにメールが表示されます。

    ![メール](https://user-images.githubusercontent.com/3375461/31968754-0ce4dafc-b8c7-11e7-8458-8152d598228e.png)

## 前提条件
<a name="prerequisites"></a>

Webhook サンプルを使うには、次が必要です。

- [Node.js](https://nodejs.org/) (バージョン 4 または 5)。
- [職場または学校のアカウント](http://dev.office.com/devprogram)。

## アプリを登録する
<a name="Register-the-app"></a>

このアプリは Azure AD エンドポイントを使用するため、[Azure ポータル](https://ms.portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade)に登録します。

1. 職場または学校のアカウントか、個人の Microsoft アカウントを使用して、Azure ポータルにサインインします。
1. ご利用のアカウントで複数のテナントにアクセスできる場合は、右上隅でアカウントを選択し、ポータルのセッションを目的の Azure AD テナントに設定します (Switch Directory を使用)。
1. 左側のナビゲーション ウィンドウで、[**Azure Active Directory] サービス**を選択し、[**アプリの登録**] を選択します。
![](readme-images/registrations.png)

1. [**新しいアプリケーションの登録**] を選択します。

    1. このアプリケーションのフレンドリ名を入力します。
    1. **アプリケーション タイプ**として [Web App/API] (Web アプリ/API) を選択します。
    1. **サインオン URL** に `http://localhost:3000/callback` と入力します。
    1. [サポートされているアカウントの種類] セクションで、[組織ディレクトリ内のアカウントと個人の Microsoft アカウント (例: Skype、Xbox、Outlook.com)] を選択します。
    1. [**作成**] をクリックします。

1. 登録済みアプリケーションの一覧から新しいアプリケーションを選択します。
アプリの [**概要**] ページで、[**Application (client) ID**] (アプリケーション (クライアント) ID) の値を確認し、後で使用するために記録します。この情報は、このプロジェクトで Visual Studio 構成ファイルを設定するのに必要になります。
![](readme-images/client.png)
1. アプリケーションのアクセス許可を構成します。

    1. [**設定**]、[**必要なアクセス許可**]、[**追加**] の順に選択します。
    1. [**API を選択します**]、[**Microsoft Graph**] を選択して、[**選択**] をクリックします。
    1. [**アクセス許可を選択**] を選択し、[**委任されたアクセス許可**] までスクロールし、[**Mail.Read**] を選択し、[**選択**] をクリックします。
    1. [**完了**] をクリックします。
	![](readme-images/permissions.png)

1. [**管理**] で [**証明書とシークレット**] を選択します。[**新しいクライアント シークレット**] ボタンを選択します。[説明] に値を入力し、[有効期限] のオプションのいずれかを選び、[**追加**] を選択します。

![](readme-images/secrets.png)

1. **重要**:キー値をコピーします--これがアプリのシークレットです。このブレードを離れた後は、この値に再度アクセスできなくなります。

アプリを構成するには、**アプリケーション ID** と**シークレット**を使用します。

## localhost のトンネルを構成する

このサンプルでは、開発サーバーとして localhost を使用しています。このため、インターネット上の URL から localhost に要求を転送できるトンネルが必要です。何らかの理由でトンネルを使用したくない場合は、「[Hosting without a tunnel (トンネルを使用しないでホストする)](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Hosting-the-sample-without-a-tunnel)」をご覧ください。トンネルを使用する理由について詳細な説明が必要な場合は、「[Why do I have to use a tunnel? (トンネルを使用する理由)](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Why-do-I-have-to-use-a-tunnel)」を参照してください。

このサンプルでは、[ngrok](https://ngrok.com/) を使用してトンネルを作成します。ngrok を構成するには:

1. プラットフォームに合った ngrok バイナリを[ダウンロード](https://ngrok.com/download)して解凍します。
1. 次のコマンドを入力します。

    ```Shell
    ngrok http 3000
    ```

1. ngrok が提供する *https パブリック URL* のメモを取ります。以下は例です。

    ```http
    https://{NGROK_ID}.ngrok.io
    ```

`NGROK_ID` 値は次のセクションで必要になります。

## Web アプリの構成して実行する

1. テキスト エディターを使用して `constants.js` を開きます。
1. `ENTER_YOUR_CLIENT_ID` を登録済みの Azure アプリケーションのクライアント ID と置き換えます。
1. `ENTER_YOUR_SECRET` を登録済みの Azure アプリケーションのクライアント シークレットと置き換えます。
1. `NGROK_ID` を前のセクションの *https パブリック URL* の値と置き換えます。
![](const)
1. 次のコマンドを実行して、依存関係をインストールします。

    ```Shell
    npm install
    ```

1. 次のコマンドを使用して、アプリケーションを起動します。

    ```Shell
    npm start
    ```
    > **注:**アプリケーションにデバッガーを待たせることもできます。デバッガーを待つには、代わりに次のコマンドを使用します。
    >
    > ```Shell
    > npm run debug
    > ```
    > Microsoft Visual Studio Code に含まれるデバッガーをアタッチすることもできます。詳細については、「[Debugging in Visual Studio Code (Visual Studio Code でのデバッグ)](https://code.visualstudio.com/Docs/editor/debugging)」を参照してください。

1. ブラウザーを開き、[http://localhost:3000](http://localhost:3000) に移動します。

## 投稿

このサンプルに投稿する場合は、[CONTRIBUTING.MD](/CONTRIBUTING.md) を参照してください。

このプロジェクトでは、[Microsoft Open Source Code of Conduct (Microsoft オープン ソース倫理規定)](https://opensource.microsoft.com/codeofconduct/) が採用されています。詳細については、「[Code of Conduct の FAQ (倫理規定の FAQ)](https://opensource.microsoft.com/codeofconduct/faq/)」を参照してください。また、その他の質問やコメントがあれば、[opencode@microsoft.com](mailto:opencode@microsoft.com) までお問い合わせください。

## 質問とコメント

Microsoft Graph Webhook サンプルに関するフィードバックをぜひお寄せください。質問や提案は、このリポジトリの「[問題](https://github.com/OfficeDev/Microsoft-Graph-NodeJs-Webhooks/issues)」セクションで送信できます。

Office 365 の開発に関する質問をお持ちですか ?[Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) に投稿しましょう。質問やコメントには、必ず [Office365] と [API] のタグを付けてください。

## その他の技術情報

- [Microsoft Graph の概要](http://graph.microsoft.io/)
- [サブスクリプション リファレンス ドキュメント](https://graph.microsoft.io/en-us/docs/api-reference/beta/resources/subscription)

## 著作権

Copyright (c) 2019 Microsoft.All rights reserved.
