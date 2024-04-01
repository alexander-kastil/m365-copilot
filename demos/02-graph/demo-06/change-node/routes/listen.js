import express from 'express';
import escape from 'escape-html';

import { ioServer } from '../helpers/socketHelper';
import { SubscriptionManagementService } from '../helpers/requestHelper';
import { getSubscription } from '../helpers/dbHelper';
import { subscriptionConfiguration, certificateConfiguration, msalConfiguration } from '../constants';
import { decryptSymetricKey, decryptPayload, verifySignature } from '../helpers/certificateHelper';
import { isTokenValid } from '../helpers/tokenHelper';

export const listenRouter = express.Router();

/* Default listen route */
listenRouter.post('/', async (req, res, next) => {
  let status;
  let clientStatesValid;

  // If there's a validationToken parameter in the query string,
  // then this is the request that Office 365 sends to check
  // that this is a valid endpoint.
  // Just send the validationToken back.
  if (req.query && req.query.validationToken) {
    res.send(escape(req.query.validationToken));
    // Send a status of 'Ok'
    status = 200;
  } else {
    clientStatesValid = false;

    // First, validate all the clientState values in array
    for (let i = 0; i < req.body.value.length; i++) {
      const clientStateValueExpected = subscriptionConfiguration.clientState;

      if (req.body.value[i].clientState !== clientStateValueExpected) {
        // If just one clientState is invalid, we discard the whole batch
        clientStatesValid = false;
        break;
      } else {
        clientStatesValid = true;
      }
    }

    // if we're receiving notifications with resource data we have to validate the origin of the request by validating the tokens
    let areTokensValid = true;
    if (req.body.validationTokens) {
      const validationResults = await Promise.all(req.body.validationTokens.map((x) => isTokenValid(x, msalConfiguration.clientID, msalConfiguration.tenantID)));
      areTokensValid = validationResults.reduce((x, y) => x && y);
    }

    // If all the clientStates are valid, then process the notification
    if (clientStatesValid && areTokensValid) {
      for (let i = 0; i < req.body.value.length; i++) {
        const resource = req.body.value[i].resource;
        const subscriptionId = req.body.value[i].subscriptionId;

        if (req.body.value[i].encryptedContent) {
          // we have a notification with resource data, let's decrypt the enclosed data
          // eslint-disable-next-line no-loop-func
          const decryptedSymetricKey = decryptSymetricKey(req.body.value[i].encryptedContent.dataKey, certificateConfiguration.relativeKeyPath);
          const isSignatureValid = verifySignature(req.body.value[i].encryptedContent.dataSignature, req.body.value[i].encryptedContent.data, decryptedSymetricKey);
          if (isSignatureValid) {
            // the signature is valid, data hasn't been tampered with. We can proceed to displaying the data
            const decryptedPayload = decryptPayload(req.body.value[i].encryptedContent.data, decryptedSymetricKey);
            emitNotification(subscriptionId, JSON.parse(decryptedPayload));
          } // otherwise data is invalid, ignore it
        } else {
          // we have a plain notification that doesn't contain data, let's call Microsoft Graph to get the resource data
          processNotification(subscriptionId, resource, res, next);
        }
      }
      // Send a status of 'Accepted'
      status = 202;
    } else {
      // Since the clientState field doesn't have the expected value,
      // or the validation tokens are invalid for notifications with data
      // this request might NOT come from Microsoft Graph.
      // However, you should still return the same status that you'd
      // return to Microsoft Graph to not alert possible impostors
      // that you have discovered them.
      status = 202;
    }
  }
  res.status(status).end();
});

function emitNotification(subscriptionId, data) {
  ioServer.to(subscriptionId).emit('notification_received', data);
}

// Get subscription data from the database
// Retrieve the entity from Microsoft Graph.
// Send the message data to the socket.
function processNotification(subscriptionId, resource, res, next) {
  getSubscription(subscriptionId, async (dbError, subscriptionData) => {
    if (subscriptionData) {
      try {
        const subscriptionManagementService = new SubscriptionManagementService(subscriptionData.accessToken);
        const endpointData = await subscriptionManagementService.getData(resource);
        emitNotification(subscriptionId, endpointData);
      } catch (requestError) {
        res.status(500);
        next(requestError);
      }
    } else if (dbError) {
      res.status(500);
      next(dbError);
    }
  });
}
