# User & group mgmt using Microsoft Graph

Get groups:

```
https://graph.microsoft.com/v1.0/groups
```

Get group owner:

```
https://graph.microsoft.com/v1.0/groups/11a924f6-6baf-4500-b056-6488c1284951/owners
```

Get the list of groups where a user is an owner:

```
https://graph.microsoft.com/v1.0/me/ownedObjects
```

Get the list of groups where a user is a member:

```
https://graph.microsoft.com/v1.0/me/memberOf
```

Create a group:

```
https://graph.microsoft.com/v1.0/groups
Content-Type	application/json
{
    "displayName": "Library Assist",
    "mailNickname": "library",
    "mailEnabled": false,
    "securityEnabled": true
}
```

Delete group:

```
https://graph.microsoft.com/v1.0/groups/c49b13f0-edf3-47ac-9968-ce25810a7010
```

## Additional Labs

[Manage Group Lifecycle with Microsoft Graph](https://docs.microsoft.com/en-us/learn/modules/msgraph-access-group-data/)