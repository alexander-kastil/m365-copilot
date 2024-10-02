using Microsoft.Graph.Models.ExternalConnectors;
using Markdig;

static class ContentService
{
  static IEnumerable<Document> Extract()
  {
    var docs = new List<Document>();

    var contentFolder = "content";
    var baseUrl = new Uri("https://learn.microsoft.com/graph/");
    var contentFolderPath = Path.Combine(Directory.GetCurrentDirectory(), contentFolder);
    var files = Directory.GetFiles(contentFolder, "*.md", SearchOption.AllDirectories);

    foreach (var file in files)
    {
      try
      {
        var contents = File.ReadAllText(file);
        var doc = contents.GetContents<Document>();
        doc.Content = Markdown.ToHtml(doc.Markdown ?? "");
        doc.RelativePath = Path.GetRelativePath(contentFolderPath, file);
        doc.Url = new Uri(baseUrl, doc.RelativePath!.Replace(".md", "")).ToString();
        doc.IconUrl = "https://raw.githubusercontent.com/waldekmastykarz/img/main/microsoft-graph.png";
        docs.Add(doc);
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex.Message);
      }
    }

    return docs;
  }

  static string GetDocId(Document doc)
  {
    var id = doc.RelativePath!
      .Replace(Path.DirectorySeparatorChar.ToString(), "__")
      .Replace(".md", "");
    return id;
  }

  static IEnumerable<ExternalItem> Transform(IEnumerable<Document> content)
  {
    var baseUrl = new Uri("https://learn.microsoft.com/graph/");

    return content.Select(a =>
    {
      var acl = new Acl
      {
        Type = AclType.Everyone,
        Value = "everyone",
        AccessType = AccessType.Grant
      };

      if (a.RelativePath!.EndsWith("use-the-api.md"))
      {
        acl = new()
        {
          Type = AclType.User,
          // AdeleV
          Value = "6de8ec04-6376-4939-ab47-83a2c85ab5f5",
          AccessType = AccessType.Grant
        };
      }
      else if (a.RelativePath.EndsWith("traverse-the-graph.md"))
      {
        acl = new()
        {
          Type = AclType.Group,
          // Sales and marketing
          Value = "a9fd282f-4634-4cba-9dd4-631a2ee83cd3",
          AccessType = AccessType.Grant
        };
      }

      var docId = GetDocId(a);

      return new ExternalItem
      {
        Id = docId,
        Properties = new()
        {
          AdditionalData = new Dictionary<string, object> {
            { "title", a.Title ?? "" },
            { "description", a.Description ?? "" },
            { "url", new Uri(baseUrl, a.RelativePath!.Replace(".md",    "")).ToString() }
    }
        },
        Content = new()
        {
          Value = a.Content ?? "",
          Type = ExternalItemContentType.Html
        },
        Acl = new()
  {
          acl
  }
      };
    });
  }

  static async Task Load(IEnumerable<ExternalItem> items)
  {
    foreach (var item in items)
    {
      Console.Write(string.Format("Loading item {0}...", item.Id));

      try
      {
        await GraphService.Client.External
          .Connections[Uri.EscapeDataString(ConnectionConfiguration.ExternalConnection.Id!)]
          .Items[item.Id]
          .PutAsync(item);

        Console.WriteLine("DONE");
      }
      catch (Exception ex)
      {
        Console.WriteLine("ERROR");
        Console.WriteLine(ex.Message);
      }
    }
  }

  public static async Task LoadContent()
  {
    var content = Extract();
    var transformed = Transform(content);
    await Load(transformed);
  }
}