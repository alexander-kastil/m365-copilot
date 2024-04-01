/* eslint-disable quotes */
exports.msalConfiguration = {
  authority: "https://login.microsoftonline.com/common",
  clientID: "7adb8d94-4233-4f7c-9563-87bdeb7ad27a",
  clientSecret: "Dlk7Q~sGQG5.WDV6rnQsYGYN9t.RTPwbKMeVx",
  tenantID: "d92b247e-90e0-4469-a129-6a32866c0d0a",
  redirectUri: "http://localhost:3000/callback",
};

exports.subscriptionConfiguration = {
  changeType: "Created",
  notificationUrl: "https://0197-80-108-224-121.ngrok.io/listen",
  resource: "me/mailFolders('Inbox')/messages",
  clientState: "cLIENTsTATEfORvALIDATION",
  includeResourceData: false,
};

exports.certificateConfiguration = {
  certificateId: "myCertificateId",
  relativeCertPath: "./certificate.pem",
  relativeKeyPath: "./key.pem",
  password: "Password123",
};
