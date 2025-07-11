using System.Text.Json;
using Microsoft.Graph.Models;
using Microsoft.Graph.Models.ExternalConnectors;

static class ConnectionConfiguration
{
    private static Dictionary<string, object>? _layout;
    private static Dictionary<string, object> Layout
    {
        get
        {
            if (_layout is null)
            {
                var adaptiveCard = File.ReadAllText("resultLayout.json");
                _layout = JsonSerializer.Deserialize<Dictionary<string, object>>(adaptiveCard);
            }

            return _layout!;
        }
    }

    public static ExternalConnection ExternalConnection
    {
        get
        {
            return new ExternalConnection
            {
                Id = "kbdocs",
                Name = "Knowledge Base Docs",
                Description = "Documentation for Microsoft Graph API, Angular Components and Semantic Kernel which explains base concepts and provides examples.",
            };
        }
    }

    public static Schema Schema
    {
        get
        {
            return new Schema
            {
                BaseType = "microsoft.graph.externalItem",
                Properties = new()
                {
                    new Property
                    {
                        Name = "title",
                        Type = PropertyType.String,
                        IsQueryable = true,
                        IsSearchable = true,
                        IsRetrievable = true,
                        Labels = new() { Label.Title }
                    },
                    new Property
                    {
                        Name = "url",
                        Type = PropertyType.String,
                        IsRetrievable = true,
                        Labels = new() { Label.Url }
                    },
                    new Property
                    {
                        Name = "iconUrl",
                        Type = PropertyType.String,
                        IsRetrievable = true,
                        Labels = new() { Label.IconUrl }
                    },
                    new Property
                        {
                            Name = "description",
                            Type = PropertyType.String,
                            IsRetrievable = true,
                            IsQueryable = true,
                            IsSearchable = true
                        },
                    }
            };
        }
    }
}