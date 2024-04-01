# Optimizing Graph

## Batching

[Combine multiple requests in one HTTP call using JSON batching](https://docs.microsoft.com/en-us/graph/json-batching)

Execute in Graph Explorer

```
POST https://graph.microsoft.com/v1.0/$batch
Accept: application/json
Content-Type: application/json
```

Body:

```json
{
    "requests": [
        {
            "url": "/me?$select=displayName,jobTitle,userPrincipalName",
            "method": "GET",
            "id": "1"
        },
        {
            "url": "/me/messages?$filter=importance eq 'high'&$select=from,subject,receivedDateTime,bodyPreview",
            "method": "GET",
            "id": "2"
        },
        {
            "url": "/me/events",
            "method": "GET",
            "id": "3"
        }
    ]
}
```

## Additional Labs

[Optimize data usage when using Microsoft Graph with query parameters](https://docs.microsoft.com/en-us/learn/modules/optimize-data-usage/)