# Build a declarative agent for Microsoft 365 Copilot

[Lab E1 - First Declarative agent](https://microsoft.github.io/copilot-camp/pages/extend-m365-copilot/01-declarative-copilot/)

# Steps

Install Teams Toolkit CLI:

```bash
npm install -g @microsoft/teamsapp-cli
teamsapp -h
```

Enable Declarative while in preview:

```bash
[Environment]::SetEnvironmentVariable("TEAMSFX_DECLARATIVE_COPILOT", 'true', "User")
[Environment]::SetEnvironmentVariable("KIOTA_CONFIG_PREVIEW", "true", "User")
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```
