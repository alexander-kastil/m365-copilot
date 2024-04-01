---
page_type: sample 
products:
- ms-graph
languages:
- nodejs
- javascript
description: "为 Node.js 应用创建 Microsoft Graph webhook 订阅，以便它可以接收用户的 Microsoft 帐户数据更改的通知。"
extensions:
  contentType: samples
  technologies:
  - Microsoft Graph
  createdDate: 3/9/2016 4:12:18 PM
---
# 面向 Node.js 的 Microsoft Graph Webhook 示例

[![生成状态](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample.svg)](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample)

## 目录。 ##
* [简介](#introduction)

* [屏幕截图](#screenshots)

* [先决条件](#prerequisites)

* [注册应用](#Register-the-app)

* [配置 localhost 隧道](#Configure-a-tunnel-for-your-localhost)

* [配置并运行 Web 应用程序](#Configure-and-run-the-web-app)

* [参与](#contributing)

* [问题和意见](#Questions-and-Comments)

* [其他资源](#Additional-resources)


## 简介
<a name="introduction"></a>

此 Node.js 示例演示如何开始从 Microsoft Graph 获取通知。下面是 Web 应用程序可通过 Microsoft Graph webhook 执行的常见任务。

- 使用工作或学校账户登录用户，以获取访问令牌。
- 使用访问令牌创建 webhook 订阅。
- 回发验证令牌以确认通知 URL。
- 侦听来自 Microsoft Graph 的通知。
- 使用通知中的数据请求 Microsoft Office 365 中的更多资源。

## 屏幕截图
<a name="screenshots"></a>

1. 首先需要登录。

    ![登录](https://user-images.githubusercontent.com/3375461/31968683-c373ad30-b8c6-11e7-9d01-413fab9fd6d5.png)

1. 登录后，应用程序将侦听传入电子邮件。

    ![侦听](https://user-images.githubusercontent.com/3375461/31968718-e19696c4-b8c6-11e7-91f2-f1806be0b134.png)

1. 发送电子邮件至地址后，将在应用程序中看到电子邮件。

    ![电子邮件](https://user-images.githubusercontent.com/3375461/31968754-0ce4dafc-b8c7-11e7-8458-8152d598228e.png)

## 先决条件
<a name="prerequisites"></a>

使用 Webhook 示例，需要以下内容：

- [Node.js](https://nodejs.org/) 版本 4 或 5。
- 一个[工作或学校帐户](http://dev.office.com/devprogram)。

## 注册应用
<a name="Register-the-app"></a>

此应用使用 Azure AD 终结点，因此将在 [Azure 门户](https://ms.portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade)中注册。

1. 使用工作/学校帐户或 Microsoft 个人帐户登录到 Azure 门户。
1. 如果你的帐户有权访问多个租户，请在右上角选择该帐户，并将门户会话设置为所需的 Azure AD 租户（使用“切换目录”）。
1. 在左侧导航窗格中选择“**Azure Active Directory 服务**”，然后选择“**应用注册**”。
![](readme-images/registrations.png)

1. 选择“**新建应用程序注册**”。

    1. 为应用程序输入一个友好的名称。
    1. 选择“Web 应用/API”作为**应用程序类型**。
    1. 在“**登录 URL**”上输入 `http://localhost:3000/callback`。
    1. 在“支持的帐户类型”部分，选择“任何组织目录中的帐户和个人 Microsoft 帐户(例如 Skype、Xbox、Outlook.com)”。
    1. 单击“**创建**”。

1. 从已注册应用的列表中选择新应用。在应用的“**概述**”页上，查找“**应用程序(客户端) ID**”值，并稍后记录下来。
你将需要它来为此项目配置 Visual Studio 配置文件。
![](readme-images/client.png)
1. 配置应用程序的权限：

    1. 选择“**设置**” > “**所需权限**” > “**添加**”。
    1. 选择“**选择 API**”页 > **Microsoft Graph**，然后单击“**选择**”。
    1. 选择 “**选择权限**”，向下滚动到“**委派权限**”，然后选择**Mail.Read**，然后单击“**选择**”。
    1. 单击“**完成**”。
	![](readme-images/permissions.png)

1. 选择**管理**下的**证书和密码**。选择**新客户端密码**按钮。在“说明”中输入数值，并选择一个“过期”选项并选择“**添加**”。

![](readme-images/secrets.png)

1. **重要说明**：复制密钥值 -- 这是应用程序的密码。离开此边栏选项卡后将无法再访问该值。

将使用此“**应用程序 ID**” 和应用“**密码**”配置应用。

## 配置 localhost 隧道

示例使用 localhost 作为开发服务器。因此，我们需要一个隧道将请求从网上 URL 转发到 localhost。如果因为任何原因不想使用隧道，参见“[无隧道托管](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Hosting-the-sample-without-a-tunnel)”。如果需要有关为什么使用隧道的详细解释，参见“[为何我需要使用隧道？](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Why-do-I-have-to-use-a-tunnel)”

对于此示例，我们使用 [ngrok](https://ngrok.com/) 创建隧道。如果要配置 ngrok：

1. 为平台“[下载](https://ngrok.com/download)”并解压 ngrok 二进制文件。
1. 键入以下命令：


    ```Shell
    ngrok http 3000
    ```

1. 记下 ngrok 提供给你的 *https 公共 URL*。这是一个示例：

    ```http
    https://{NGROK_ID}.ngrok.io
    ```

在下一节中将需要 `NGROK_ID` 值。

## 配置并运行 Web 应用程序

1. 使用文本编辑器打开 `constants.js`。
1. 用所注册的 Azure 应用程序的客户端 ID 替换 `ENTER_YOUR_CLIENT_ID`。
1. 用所注册的 Azure 应用程序的客户端密码替换 `ENTER_YOUR_SECRET`。
1. 将 `NGROK_ID` 替换为上一节中的*https 公共 URL* 值。
![](const)
1. 安装运行下列命令的依赖项：

    ```Shell
    npm install
    ```

1. 使用下列命令启动应用程序：

    ```Shell
    npm start
    ```
    > **注意：**也可以使应用程序等待调试程序。若要等待调试程序，请改用以下命令：
    >
    > ```Shell
    > npm run debug
    > ```
    > 也可附加包含的调试程序至 Visual Studio Code 中。有关详细信息，请参阅“[使用 Visual Studio Code 调试](https://code.visualstudio.com/Docs/editor/debugging)”。

1. 打开浏览器并转到 [http://localhost:3000](http://localhost:3000)。

## 参与

如果想要参与本示例，请参阅 [CONTRIBUTING.MD](/CONTRIBUTING.md)。

此项目已采用 [Microsoft 开放源代码行为准则](https://opensource.microsoft.com/codeofconduct/)。有关详细信息，请参阅[行为准则 FAQ](https://opensource.microsoft.com/codeofconduct/faq/)。如有其他任何问题或意见，也可联系 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

## 问题和意见

我们乐意倾听你有关 Microsoft Graph Webhook 示例的反馈。你可通过该存储库中的[问题](https://github.com/OfficeDev/Microsoft-Graph-NodeJs-Webhooks/issues)部分向我们发送问题和建议。

Office 365 开发问题？发布到“[堆栈溢出](http://stackoverflow.com/questions/tagged/Office365+API)”。确保使用 \[Office365] 和 \[API] 标记问题或意见。

## 其他资源

- [Microsoft Graph 概述](http://graph.microsoft.io/)
- [订阅参考文档](https://graph.microsoft.io/en-us/docs/api-reference/beta/resources/subscription)

## 版权信息

版权所有 (c) 2019 Microsoft。保留所有权利。
