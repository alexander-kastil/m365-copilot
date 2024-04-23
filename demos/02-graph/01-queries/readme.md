# Using Graph and Query Params

[MS Graph Query Params](https://docs.microsoft.com/en-us/graph/query-parameters)

-   Use Graph in .NET use App Reg graph-console
-   Ad-hoc Demos

# Ad-hoc Demos

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