// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

const { TurnContext, MessageFactory, TeamsActivityHandler, CardFactory, ActionTypes } = require("botbuilder");

class BotActivityHandler extends TeamsActivityHandler {
  constructor() {
    super();
  }

  // Invoked when the service receives an incoming search query.
  async handleTeamsMessagingExtensionQuery(context, query) {
    const axios = require("axios");
    const querystring = require("querystring");

    const searchQuery = query.parameters[0].value;
    const response = await axios.get(`http://registry.npmjs.com/-/v1/search?${querystring.stringify({ text: searchQuery, size: 8 })}`);

    const attachments = [];
    response.data.objects.forEach((obj) => {
      const heroCard = CardFactory.heroCard(obj.package.name);
      const preview = CardFactory.heroCard(obj.package.name); // Preview cards are optional for Hero card. You need them for Adaptive Cards.
      preview.content.tap = { type: "invoke", value: { description: obj.package.description } };
      const attachment = { ...heroCard, preview };
      attachments.push(attachment);
    });

    return {
      composeExtension: {
        type: "result",
        attachmentLayout: "list",
        attachments: attachments,
      },
    };
  }

  // Invoked when the user selects an item from the search result list returned above.
  async handleTeamsMessagingExtensionSelectItem(context, obj) {
    return {
      composeExtension: {
        type: "result",
        attachmentLayout: "list",
        attachments: [CardFactory.thumbnailCard(obj.description)],
      },
    };
  }

  /* Messaging Extension - Unfurling Link */
  handleTeamsAppBasedLinkQuery(context, query) {
    const attachment = CardFactory.thumbnailCard("Thumbnail Card", query.url, ["https://raw.githubusercontent.com/microsoft/botframework-sdk/master/icon.png"]);

    const result = {
      attachmentLayout: "list",
      type: "result",
      attachments: [attachment],
    };

    const response = {
      composeExtension: result,
    };
    return response;
  }
  /* Messaging Extension - Unfurling Link */
}

module.exports.BotActivityHandler = BotActivityHandler;
