import { CardFactory, MemoryStorage, MessageFactory, TurnContext } from "botbuilder";
import * as path from "path";
import config from "../config";
// See https://aka.ms/teams-ai-library to learn more about the Teams AI library.
import { Application, ActionPlanner, OpenAIModel, PromptManager, AI, PredictedSayCommand, AuthError, TurnState } from "@microsoft/teams-ai";
import fs from 'fs';
import { createResponseCard } from './card';
import { Client } from "@microsoft/microsoft-graph-client";

// Create AI components
const model = new OpenAIModel({
  azureApiKey: config.azureOpenAIKey,
  azureDefaultDeployment: config.azureOpenAIDeploymentName,
  azureEndpoint: config.azureOpenAIEndpoint,

  useSystemMessages: true,
  logRequests: true,
  azureApiVersion: '2024-02-15-preview'
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
    });

    return template;
  }
});

// Define storage and application
const storage = new MemoryStorage();

const app = new Application({
  storage,
  authentication: {
    settings: {
      graph: {
        scopes: ['User.Read'],
        msalConfig: {
          auth: {
            clientId: config.aadAppClientId!,
            clientSecret: config.aadAppClientSecret!,
            authority: `${config.aadAppOauthAuthorityHost}/common`
          }
        },
        signInLink: `https://${config.botDomain}/auth-start.html`,
        endOnInvalidMessage: true
      }
    }
  },
  ai: {
    planner,
    //feedback loop is enabled
    enable_feedback_loop: true
  },
});

interface ConversationState {
  count: number;
}

type ApplicationTurnState = TurnState<ConversationState>;
app.authentication.get('graph').onUserSignInSuccess(async (context: TurnContext, state: ApplicationTurnState) => {
  const token = state.temp.authTokens['graph'];
  await context.sendActivity(`Hello ${await getUserDisplayName(token)}. You have successfully logged in to CareerGenie!`);
});
app.authentication
  .get('graph')
  .onUserSignInFailure(async (context: TurnContext, _state: ApplicationTurnState, error: AuthError) => {
    await context.sendActivity('Failed to login');
    await context.sendActivity(`Error message: ${error.message}`);
  });

// Listen for user to say '/reset' and then delete conversation state
app.message('/reset', async (context: TurnContext, state: ApplicationTurnState) => {
  state.deleteConversationState();
  await context.sendActivity(`Ok I've deleted the current conversation state.`);
});

app.message('/signout', async (context: TurnContext, state: ApplicationTurnState) => {
  await app.authentication.signOutUser(context, state);

  // Echo back users request
  await context.sendActivity(`You have signed out`);
});

async function getUserDisplayName(token: string): Promise<string | undefined> {
  let displayName: string | undefined;

  const client = Client.init({
    authProvider: (done) => {
      done(null, token);
    }
  });

  try {
    const user = await client.api('/me').get();
    displayName = user.displayName;
  } catch (error) {
    console.log(`Error calling Graph SDK in getUserDisplayName: ${error}`);
  }

  return displayName;
}

// feedback loop handler
app.feedbackLoop(async (_context, _state, feedbackLoopData) => {
  if (feedbackLoopData.actionValue.reaction === 'like') {
    console.log('👍' + ' ' + feedbackLoopData.actionValue.feedback!);
  } else {
    console.log('👎' + ' ' + feedbackLoopData.actionValue.feedback!);
  }
});

// customize citation with PredictedSayCommand and AdaptiveCard
app.ai.action<PredictedSayCommand>(AI.SayCommandActionName, async (context, state, data, action) => {
  let activity;
  if (data.response.context && data.response.context.citations.length > 0) {
    const attachment = CardFactory.adaptiveCard(createResponseCard(data.response));
    activity = MessageFactory.attachment(attachment);
  }
  else {
    activity = MessageFactory.text(data.response.content);
  }

  activity.entities = [
    {
      type: "https://schema.org/Message",
      "@type": "Message",
      "@context": "https://schema.org",
      "@id": "",
      // Generated by AI label
      additionalType: ["AIGeneratedContent"],
      // Sensitivity label
      usageInfo: {
        "@type": "CreativeWork",
        name: "Confidential",
        description: "Sensitive information, do not share outside of your organization.",
      }
    },

  ];
  activity.channelData = {
    feedbackLoopEnabled: true
  };

  await context.sendActivity(activity);

  return "success";

});

export default app;
