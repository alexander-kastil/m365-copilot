import { MemoryStorage, MessageFactory, TurnContext } from "botbuilder";
import * as path from "path";
import config from "../config";
import fs from 'fs';

// See https://aka.ms/teams-ai-library to learn more about the Teams AI library.
import { Application, ActionPlanner, OpenAIModel, PromptManager } from "@microsoft/teams-ai";

// Create AI components. remove azureApiVersion
const model = new OpenAIModel({
  azureApiKey: config.azureOpenAIKey,
  azureDefaultDeployment: config.azureOpenAIDeploymentName,
  azureApiVersion: '2024-02-15-preview',
  azureEndpoint: config.azureOpenAIEndpoint,
  useSystemMessages: true,
  logRequests: true,
});

const prompts = new PromptManager({
  promptsFolder: path.join(__dirname, "../prompts"),
});

const planner = new ActionPlanner({
  model,
  prompts,
  defaultPrompt: async () => {
    const template = await prompts.getPrompt('chat');
    const skprompt = fs.readFileSync(path.join(__dirname, '..', 'prompts', 'chat', 'skprompt.txt'));

    const dataSources = (template.config.completion as any)['data_sources'];

    dataSources.forEach((dataSource: any) => {
      if (dataSource.type === 'azure_search') {
        dataSource.parameters.authentication.key = config.azureSearchKey;
        dataSource.parameters.endpoint = config.azureSearchEndpoint;
        dataSource.parameters.indexName = config.indexName;
        dataSource.parameters.embedding_dependency.deployment_name =
          config.azureOpenAIEmbeddingDeploymentName;
        dataSource.parameters.role_information = `${skprompt.toString('utf-8')}`;
      }
      //todo: remove hardcoded values
      // if (dataSource.type === 'azure_search') {
      //   dataSource.parameters.authentication.key = 'nmrhRuMW952GoLwUJu7baujviRcQWbxdnpuTVn3Lb5AzSeD6KZaX';
      //   dataSource.parameters.endpoint = 'https://m365-copilot-search.search.windows.net'
      //   dataSource.parameters.indexName = 'resumes';
      //   dataSource.parameters.embedding_dependency.deployment_name = 'text-embedding-ada-002';
      //   dataSource.parameters.role_information = `${skprompt.toString('utf-8')}`;
      // }
    });

    return template;
  }
});

// Define storage and application
const storage = new MemoryStorage();
const app = new Application({
  storage,
  ai: {
    planner,
  },
});

app.conversationUpdate("membersAdded", async (turnContext: TurnContext) => {
  const welcomeText = "How can I help you today?";
  for (const member of turnContext.activity.membersAdded) {
    if (member.id !== turnContext.activity.recipient.id) {
      await turnContext.sendActivity(MessageFactory.text(welcomeText));
    }
  }
});

export default app;
