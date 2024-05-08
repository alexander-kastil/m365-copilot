# Using Graph and Query Params

## Links & Resources

[Use the Microsoft Search API to query data](https://learn.microsoft.com/en-us/graph/api/resources/search-api-overview?view=graph-rest-1.0)

[Use query parameters to customize responses](https://learn.microsoft.com/en-us/graph/query-parameters?tabs=http)

## Demos

$select:

```
https://graph.microsoft.com/v1.0/me/messages?$select=from,subject
```

$orderby:

```
https://graph.microsoft.com/v1.0/users?$orderby=displayName
```

$top:

```
https://graph.microsoft.com/v1.0/users?$top=2
```

$skip:

```
https://graph.microsoft.com/v1.0/me/events?$orderby=createdDateTime&desc$skip=10
```

$expand:

```
https://graph.microsoft.com/v1.0/me/drive/root?$expand=children
```

$search:

```
https://graph.microsoft.com/v1.0/me/messages?$search="pizza"
```

## Additional Labs & Walkthroughs

[Optimize data usage when using Microsoft Graph with query parameters](https://docs.microsoft.com/en-us/learn/modules/optimize-data-usage/?ns-enrollment-type=LearningPath&ns-enrollment-id=learn-m365.msgraph-associate)