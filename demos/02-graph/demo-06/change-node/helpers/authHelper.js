import { ConfidentialClientApplication } from '@azure/msal-node';

import { msalConfiguration } from '../constants';

const resource = 'https://graph.microsoft.com/.default';

/**
 * Generate a fully formed uri to use for authentication based on the supplied resource argument
 * @return {string} a fully formed uri with which authentication can be completed.
 */
export function getAuthUrl() {
  const authContext = new ConfidentialClientApplication({
    auth: {
      clientId: msalConfiguration.clientID,
      authority: msalConfiguration.authority.replace('common', msalConfiguration.tenantID),
      clientSecret: msalConfiguration.clientSecret
    }
  });
  return authContext.getAuthCodeUrl({
    redirectUri: msalConfiguration.redirectUri
  });
}

/**
 * Gets a token for a given resource.
 * @param {string} code An authorization code returned from a client.
 * @param {AcquireTokenCallback} callback The callback function.
 */
export function getTokenFromCode(code) {
  const authContext = new ConfidentialClientApplication({
    auth: {
      clientId: msalConfiguration.clientID,
      authority: msalConfiguration.authority.replace('common', msalConfiguration.tenantID),
      clientSecret: msalConfiguration.clientSecret
    }
  });
  return authContext.acquireTokenByCode({
    code: code,
    redirectUri: msalConfiguration.redirectUri,
    scopes: [resource]
  });
}

export function getAppOnlyToken() {
  const authContext = new ConfidentialClientApplication({
    auth: {
      clientId: msalConfiguration.clientID,
      authority: msalConfiguration.authority.replace('common', msalConfiguration.tenantID),
      clientSecret: msalConfiguration.clientSecret
    }
  });
  return authContext.acquireTokenByClientCredential({
    scopes: [resource]
  });
}
