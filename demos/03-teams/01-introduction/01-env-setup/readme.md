# Environment Setup

[Get started with Microsoft Teams app development](https://docs.microsoft.com/en-us/microsoftteams/platform/build-your-first-app/build-first-app-overview#get-prerequisites)

[Yeoman Generator Teams](https://github.com/pnp/generator-teams)

### Enable Upload of custom apps in tenant

Go to [Teams Admin Center](https://admin.teams.microsoft.com/):

Go to policies:

![setup-pol](_images/setup-pol.jpg)

Enable upload of custom apps:

![enable-upload](_images/enable-upload.jpg)

## Install Yeoman Generator Teams

For Teams Development a tool called [ngrok](https://ngrok.com/download) is required. Ngrok provides a secure incoming tunnel that is required to allow incoming requests used for bots and messaging extensions

![ngrok](_images/ngrok.png)

Before installing anything you can check your environment for global node packages and their version:

```
npm list -g --depth 0
```

Install Generators:

```
npm i -g yo gulp-cli typescript generator-teams
```
