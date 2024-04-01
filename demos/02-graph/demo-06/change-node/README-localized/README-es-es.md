---
page_type: sample 
products:
- ms-graph
languages:
- nodejs
- javascript
description: "Cree suscripciones de webhook de Microsoft Graph para una aplicación Node.js, para que pueda recibir notificaciones de cambios en los datos de la cuenta de Microsoft de un usuario."
extensions:
  contentType: samples
  technologies:
  - Microsoft Graph
  createdDate: 3/9/2016 4:12:18 PM
---
# Ejemplo de webhooks de Microsoft Graph para Node.js

[![Estado de la compilación](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample.svg)](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample)

## Tabla de contenido. ##
* [Introducción](#introduction)

* [Capturas de pantalla](#screenshots)

* [Requisitos previos](#prerequisites)

* [Registrar la aplicación](#Register-the-app)

* [Configurar un túnel para el localhost](#Configure-a-tunnel-for-your-localhost)

* [Configurar y ejecutar la aplicación web](#Configure-and-run-the-web-app)

* [Colaboradores](#contributing)

* [Preguntas y comentarios](#Questions-and-Comments)

* [Recursos adicionales](#Additional-resources)


## Introducción
<a name="introduction"></a>

En este ejemplo de Node.js, se muestra cómo empezar a recibir notificaciones de Microsoft Graph. Las tareas comunes que una aplicación web realiza con los webhooks Microsoft Graph.

- Inicie sesión con la cuenta profesional o educativa de los usuarios para obtener un token de acceso.
- Usar el token de acceso para crear una suscripción de webhook.
- Devuelva un token de validación para confirmar la dirección URL de notificación.
- Preste atención a las notificaciones de Microsoft Graph.
- Solicite más información en Microsoft Office 365 usando datos en la notificación.

## Capturas de pantalla
<a name="screenshots"></a>

1. En primer lugar, necesita iniciar sesión.

    ![iniciar sesión](https://user-images.githubusercontent.com/3375461/31968683-c373ad30-b8c6-11e7-9d01-413fab9fd6d5.png)

1. Una vez que haya iniciado sesión, la aplicación atenderá los correos electrónicos entrantes.

    ![atender](https://user-images.githubusercontent.com/3375461/31968718-e19696c4-b8c6-11e7-91f2-f1806be0b134.png)

1. Después de enviar el correo electrónico a la dirección, verá el correo electrónico en la aplicación.

    ![correo electrónico](https://user-images.githubusercontent.com/3375461/31968754-0ce4dafc-b8c7-11e7-8458-8152d598228e.png)

## Requisitos previos
<a name="prerequisites"></a>

Para usar el ejemplo de webhook, necesita lo siguiente:

- [Node.js](https://nodejs.org/) (versión 4 o 5)
- Una [cuenta profesional o educativa](http://dev.office.com/devprogram).

## Registrar la aplicación
<a name="Register-the-app"></a>

Esta aplicación usa el extremo de Azure AD, por lo que puede registrarlo en [Azure Portal](https://ms.portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade).

1. Inicie sesión en Microsoft Azure Portal con una cuenta personal, profesional o educativa de Microsoft.
1. Si su cuenta le da acceso a más de un inquilino, seleccione su cuenta en la esquina superior derecha y establezca su sesión de portal con el inquilino Azure AD deseado (usando cambiar directorio).
1. En el panel de navegación de la izquierda, seleccione el **servicio de Azure Active Directory**, y luego seleccione **registros de aplicaciones.** ![](readme-images/registrations.png)

1. Seleccione **Nuevo registro de aplicaciones**.

    1. Escriba un nombre descriptivo para la aplicación.
    1. Seleccione “Aplicación web o API” como **Tipo de aplicación**.
    1. Escriba `http://localhost:3000/callback` para la **URL de inicio de sesión**.
    1. En la sección tipos de cuentas admitidas, seleccione cuentas en cualquier directorio organizacional y cuentas personales de Microsoft (por ejemplo, Skype, Xbox, Outlook.com).
    1. Haga clic en **Crear**.

1. Escoja la nueva aplicación de la lista de aplicaciones registradas.
En la página **Información general** de la aplicación, busque el valor **Id. de la aplicación (cliente)** y guárdelo para más tarde.
Lo necesitará para configurar el archivo de configuración de Visual Studio para este proyecto.
![](readme-images/client.png)
1. Configurar los permisos de la aplicación:

    1. Seleccione **Configuración** > **Permisos necesarios** > **Agregar**.
    1. Escoja **Seleccionar una API** > **Microsoft Graph** y después haga clic en **Seleccionar**.
    1. Elija **Seleccionar permisos**, desplácese hasta **Permisos delegados**, elija **Mail.Read** y después haga clic en **Seleccionar**.
    1. Haga clic en **Listo**.
	![](readme-images/permissions.png)

1. Seleccione **Certificados y secretos** en **Administrar**. Seleccione el botón **Nuevo secreto de cliente**. Escriba un valor en Descripción y seleccione una de las opciones de Expirar y luego seleccione **Agregar**.

![](readme-images/secrets.png)

1. **Importante**: Copie el valor clave: este es el secreto de la aplicación. No podrá volver a obtener acceso a este valor una vez que abandone esta hoja.

Deberá usar el **ID** y el **secreto de aplicación** para configurarla.

## Configurar un túnel para el localhost

El ejemplo usa localhost como servidor de desarrollo. Por este motivo, es necesario un túnel que pueda reenviar las solicitudes de una dirección URL de Internet a su localhost. Si, por algún motivo, no desea usar un túnel, vea [Hosting without a tunnel](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Hosting-the-sample-without-a-tunnel) (Hospedar sin un túnel). Si desea obtener una explicación detallada sobre los motivos por los que debe usar un túnel, vea [Why do I have to use a tunnel?](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Why-do-I-have-to-use-a-tunnel) (¿Por qué tengo que usar un túnel?)

Para este ejemplo, usamos [ngrok](https://ngrok.com/) para crear el túnel. Para configurar ngrok:

1. [Descargue](https://ngrok.com/download) y descomprima los archivos binarios de ngrok para su plataforma.
1. Escriba el siguiente comando:

    ```Shell
    ngrok http 3000
    ```

1. Tome nota de la *dirección URL pública https* que ngrok le proporciona. Este es un ejemplo:

    ```http
    https://{NGROK_ID}.ngrok.io
    ```

Necesitará el valor `NGROK_ID` en la siguiente sección.

## Configurar y ejecutar la aplicación web

1. Use un editor de texto para abrir `constants.js`.
1. Reemplace `ENTER_YOUR_CLIENT_ID` por el identificador de cliente de la aplicación registrada en Azure.
1. Reemplace `ENTER_YOUR_SECRET` con el secreto de cliente de la aplicación registrada en Azure.
1. Reemplace `NGROK_ID` con el valor de *dirección URL https pública* de la sección anterior.
![](const)
1. Instale las dependencias ejecutando el siguiente comando:

    ```Shell
    npm install
    ```

1. Inicie la aplicación de con el siguiente comando:

    ```Shell
    npm start
    ```
    > **Nota:** También puede hacer que la aplicación espere a un depurador. Para esperar a un depurador, utilice el siguiente comando en su lugar:
    >
    > ```Shell
    > npm run debug
    > ```
	También puede adjuntar el depurador incluido en Microsoft Visual Studio Code. Para más información, vea [Debugging in Visual Studio Code](https://code.visualstudio.com/Docs/editor/debugging) (Depurar con Visual Studio Code).

1. Abra el explorador y vaya a [http://localhost:3000](http://localhost:3000).

## Colaboradores

Si quiere hacer su aportación a este ejemplo, vea [CONTRIBUTING.MD](/CONTRIBUTING.md).

Este proyecto ha adoptado el [Código de conducta de código abierto de Microsoft](https://opensource.microsoft.com/codeofconduct/). Para obtener más información, vea [Preguntas frecuentes sobre el código de conducta](https://opensource.microsoft.com/codeofconduct/faq/) o póngase en contacto con [opencode@microsoft.com](mailto:opencode@microsoft.com) si tiene otras preguntas o comentarios.

## Preguntas y comentarios

Nos encantaría recibir sus comentarios acerca del ejemplo de Webhook de Microsoft Graph. Puede enviarnos sus preguntas y sugerencias a través de la sección [Problemas](https://github.com/OfficeDev/Microsoft-Graph-NodeJs-Webhooks/issues) de este repositorio.

¿Tiene preguntas sobre el desarrollo de Office 365? Publíquelas en [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Asegúrese de etiquetar sus preguntas o comentarios con \[Office365] y \[API].

## Recursos adicionales

- [Información general de Microsoft Graph](http://graph.microsoft.io/)
- [Documentación de referencia de la suscripción](https://graph.microsoft.io/en-us/docs/api-reference/beta/resources/subscription)

## Derechos de autor

Copyright (c) 2019 Microsoft. Todos los derechos reservados.
