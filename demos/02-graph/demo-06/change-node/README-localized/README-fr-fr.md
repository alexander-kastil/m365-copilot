---
page_type: sample 
products:
- ms-graph
languages:
- nodejs
- javascript
description: "Créez des abonnements webhook Microsoft Graph pour une application Node.js afin qu’elle puisse recevoir des notifications lorsque des modifications sont apportées aux données de compte Microsoft d’un utilisateur."
extensions:
  contentType: samples
  technologies:
  - Microsoft Graph
  createdDate: 3/9/2016 4:12:18 PM
---
# Exemple de webhooks Microsoft Graph pour Node.js

[![État de création](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample.svg)](https://travis-ci.org/microsoftgraph/nodejs-webhooks-rest-sample)

## Table des matières. ##
* [Introduction](#introduction)

* [Captures d’écran](#screenshots)

* [Conditions préalables](#prerequisites)

* [Inscription de l’application](#Register-the-app)

* [Configurer un tunnel pour votre localhost](#Configure-a-tunnel-for-your-localhost)

* [Configurer et exécuter l’application web](#Configure-and-run-the-web-app)

* [Contribution](#contributing)

* [Questions et commentaires](#Questions-and-Comments)

* [Ressources supplémentaires](#Additional-resources)


## Introduction
<a name="introduction"></a>

Cet exemple Node.js présente comment commencer à recevoir des notifications de Microsoft Graph. Voici les tâches habituelles qu’une application web effectue avec des webhooks Microsoft Graph.

- Connectez vos utilisateurs à l’aide de leur compte professionnel ou scolaire pour l'obtention d'un jeton d’accès.
- Utiliser le jeton d'accès pour créer un abonnement webhook.
- Renvoyez un jeton de validation pour confirmer l'URL de notification.
- Surveillez les notifications provenant de Microsoft Graph.
- Demandez davantage d’informations dans Microsoft Office 365 en utilisant les données de la notification.

## Captures d’écran
<a name="screenshots"></a>

1. Vous devez tout d'abord vous connecter.

    ![Se connecter](https://user-images.githubusercontent.com/3375461/31968683-c373ad30-b8c6-11e7-9d01-413fab9fd6d5.png)

1. Une fois connecté, l’application observe les messages électroniques entrants.

    ![observation](https://user-images.githubusercontent.com/3375461/31968718-e19696c4-b8c6-11e7-91f2-f1806be0b134.png)

1. Après envoi de l'e-mail vers l’adresse, celui-ci apparaît dans l’application.

    ![e-mail](https://user-images.githubusercontent.com/3375461/31968754-0ce4dafc-b8c7-11e7-8458-8152d598228e.png)

## Conditions préalables
<a name="prerequisites"></a>

Pour utiliser l'exemple webhook, l'élément suivant est nécessaire :

- [Node.js](https://nodejs.org/) version 4 ou 5.
- Un [compte professionnel ou scolaire](http://dev.office.com/devprogram).

## Inscription de l’application
<a name="Register-the-app"></a>

Cette application utilise le point de terminaison Azure Active Directory. Vous devez donc l’enregistrer sur le [Portail Azure](https://ms.portal.azure.com/#blade/Microsoft_AAD_IAM/ApplicationsListBlade).

1. Connectez-vous au portail Microsoft Azure à l’aide d’un compte professionnel ou scolaire, ou d’un compte Microsoft personnel.
1. Si votre compte vous propose un accès à plusieurs clients, sélectionnez votre compte en haut à droite et définissez votre session de portail sur le client Azure AD souhaité (à l’aide de Changer de répertoire).
1. Dans le volet de navigation gauche, sélectionnez le service **Azure Active Directory**, puis sélectionnez **Inscriptions d’applications**
![](readme-images/registrations.png).

1. Choisissez **Nouvelle inscription d’application**.

    1. Entrez un nom convivial pour l’application.
    1. Choisissez « Web app/API » en tant que **Type d'application**.
    1. Entrez `http://localhost:3000/callback` comme **URL de connexion**.
    1. Dans la section types de comptes pris en charge, sélectionnez Comptes dans un annuaire organisationnel et les comptes personnels Microsoft (par ex. Skype, Xbox, Outlook.com).
    1. Cliquez sur **Créer**.

1. Choisissez votre nouvelle application dans la liste des applications enregistrées.
Sur la page **Vue d’ensemble** de l’application, notez la valeur d'**ID d’application (client)** et conservez-la pour plus tard. Vous devez paramétrer le fichier de configuration de Visual Studio pour ce projet.
![](readme-images/client.png)
1. Configurez les autorisations pour votre application :

    1. Choisissez **Paramètres** > **Autorisations nécessaires** > **Ajouter**.
    1. Choisissez **Sélectionner une API** > **Microsoft Graph**, puis cliquez sur **Sélectionner**.
    1. Choisissez **Sélectionner des autorisations**, faites défiler vers le bas jusqu’à **Autorisations déléguées**, sélectionnez **Mail.Read**, puis cliquez sur **Sélectionner**.
    1. Cliquez sur **Terminé**.
	![](readme-images/permissions.png)

1. Sélectionnez **Certificats & secrets** sous **Gérer**. Sélectionnez le bouton **Nouvelle clé secrète client**. Entrez une valeur dans la Description, puis sélectionnez l'une des options pour Expire le, et choisissez **Ajouter**.

![](readme-images/secrets.png)

1. **Important** : Copier la valeur de clé : elle constitue le secret de votre application. Vous ne pourrez pas accéder de nouveau à cette valeur après avoir quitté ce panneau.

Vous utiliserez l’**ID de l’application** et le **secret** pour configurer l’application.

## Configurer un tunnel pour votre localhost

L’exemple utilise localhost en tant que serveur de développement. Un tunnel est par conséquent nécessaire pour transférer les demandes d’une URL sur Internet vers votre localhost. Si, pour une raison quelconque, vous ne souhaitez pas utiliser de tunnel, consultez l'[Hébergement sans tunnel](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Hosting-the-sample-without-a-tunnel). Pour obtenir des explications détaillées sur l’utilisation d’un tunnel, consultez [Pourquoi dois-je utiliser un tunnel ?](https://github.com/OfficeDev/Microsoft-Graph-Nodejs-Webhooks/wiki/Why-do-I-have-to-use-a-tunnel)

Dans cet exemple, [ngrok](https://ngrok.com/) est utilisé pour créer le tunnel. Configuration de ngrok :

1. [Télécharger](https://ngrok.com/download) et décompresser des fichiers binaires ngrok pour votre plateforme.
1. Tapez la commande suivante :

    ```Shell
    ngrok http 3000
    ```

1. Notez l’*URL publique https* fourni par ngrok. Voici un exemple :

    ```http
    https://{NGROK_ID}.ngrok.io
    ```

La valeur `NGROK_ID` est nécessaire dans la section suivante.

## Configurer et exécuter l’application web

1. Utilisez un éditeur de texte pour ouvrir `constants.js`.
1. Remplacez `ENTER_YOUR_CLIENT_ID` par l’ID client de votre application Azure enregistrée.
1. Remplacez `ENTER_YOUR_SECRET` par la clé secrète client de votre application Azure enregistrée.
1. Remplacez `NGROK_ID` par la valeur dans l'*URL public https* de la section précédente.
![](const)
1. Installez les dépendances exécutant la commande suivante :

    ```Shell
    npm install
    ```

1. Démarrez l’application avec la commande suivante :

    ```Shell
    npm start
    ```
    > **Remarque :** Vous pouvez également faire en sorte que l'application attende un débogueur. Pour l'attente d'un débogueur, utilisez la commande suivante à la place :
    >
    > ```Shell
    > npm run debug
    > ```
    > Vous pouvez également joindre le débogueur inclus dans Microsoft Visual Studio Code. Pour plus d’informations, consultez le [Débogage dans Visual Studio Code](https://code.visualstudio.com/Docs/editor/debugging).

1. Ouvrez votre navigateur et accédez à [http://localhost:3000](http://localhost:3000).

## Contribution

Si vous souhaitez contribuer à cet exemple, voir [CONTRIBUTING.MD](/CONTRIBUTING.md).

Ce projet a adopté le [code de conduite Open Source de Microsoft](https://opensource.microsoft.com/codeofconduct/). Pour en savoir plus, reportez-vous à la [FAQ relative au code de conduite](https://opensource.microsoft.com/codeofconduct/faq/) ou contactez [opencode@microsoft.com](mailto:opencode@microsoft.com) pour toute question ou tout commentaire.

## Questions et commentaires

Nous serions ravis de connaître votre opinion sur l'application de l'exemple de webhook Microsoft Graph. Vous pouvez nous faire part de vos questions et suggestions dans la rubrique [Problèmes](https://github.com/OfficeDev/Microsoft-Graph-NodeJs-Webhooks/issues) de ce référentiel.

Vous avez des questions sur le développement dans Office 365 ? Publiez-les sur [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). N'oubliez pas de poser vos questions ou commentaires en incluant les balises \[API] et \[Office365].

## Ressources supplémentaires

- [Présentation de Microsoft Graph](http://graph.microsoft.io/)
- [Documentation de référence sur l'inscription](https://graph.microsoft.io/en-us/docs/api-reference/beta/resources/subscription)

## Copyright

Copyright (c) 2019 Microsoft. Tous droits réservés.
