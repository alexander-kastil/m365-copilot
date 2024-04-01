import fs from 'fs';
import sql from 'sqlite3';

const dbFile = './helpers/database.sqlite3';
const sqlite3 = sql.verbose();

/**
 * Create SQLite3 table Subscription.
 */
export function createDatabase() {
  const dbExists = fs.existsSync(dbFile);
  const db = new sqlite3.Database(dbFile);
  const createSubscriptionStatement = 'CREATE TABLE Subscription ('
    + 'SubscriptionId TEXT NOT NULL, '
    + 'AccessToken TEXT NOT NULL, '
    + 'Resource TEXT NOT NULL, '
    + 'ChangeType TEXT NOT NULL, '
    + 'ClientState TEXT NOT NULL, '
    + 'NotificationUrl TEXT NOT NULL, '
    + 'SubscriptionExpirationDateTime TEXT NOT NULL'
    + ')';

  db.serialize(() => {
    if (!dbExists) {
      db.run(
        createSubscriptionStatement,
        [],
        error => {
          if (error !== null) throw error;
        }
      );
    }
  });
  db.close();
}

export function getSubscription(subscriptionId, callback) {
  const db = new sqlite3.Database(dbFile);
  const getUserDataStatement = 'SELECT '
    + 'SubscriptionId as subscriptionId, '
    + 'AccessToken as accessToken, '
    + 'Resource as resource, '
    + 'ChangeType as changeType, '
    + 'ClientState as clientState, '
    + 'NotificationUrl as notificationUrl, '
    + 'SubscriptionExpirationDateTime as subscriptionExpirationDateTime '
    + 'FROM Subscription '
    + 'WHERE SubscriptionId = $subscriptionId '
    + 'AND SubscriptionExpirationDateTime > datetime(\'now\')';

  db.serialize(() => {
    db.get(
      getUserDataStatement,
      {
        $subscriptionId: subscriptionId
      },
      callback
    );
  });
}

export function saveSubscription(subscriptionData, callback) {
  const db = new sqlite3.Database(dbFile);
  const insertStatement = 'INSERT INTO Subscription '
    + '(SubscriptionId, AccessToken, Resource, ChangeType, '
    + 'ClientState, NotificationUrl, SubscriptionExpirationDateTime) '
    + 'VALUES ($subscriptionId, $accessToken, $resource, $changeType, '
    + '$clientState, $notificationUrl, $subscriptionExpirationDateTime)';

  db.serialize(() => {
    db.run(
      insertStatement,
      {
        $subscriptionId: subscriptionData.id,
        $accessToken: subscriptionData.accessToken,
        $resource: subscriptionData.resource,
        $clientState: subscriptionData.clientState,
        $changeType: subscriptionData.changeType,
        $notificationUrl: subscriptionData.notificationUrl,
        $subscriptionExpirationDateTime: subscriptionData.expirationDateTime
      },
      callback
    );
  });
}

export function deleteSubscription(subscriptionId, callback) {
  const db = new sqlite3.Database(dbFile);
  const deleteStatement = 'DELETE FROM Subscription WHERE '
    + 'SubscriptionId = $subscriptionId';

  db.serialize(() => {
    db.run(
      deleteStatement,
      { $subscriptionId: subscriptionId },
      callback
    );
  });
}
