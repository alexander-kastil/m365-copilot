using Microsoft.Graph.Models.ExternalConnectors;
using YamlDotNet.Serialization;
using Markdig;

public interface IMarkdown
{
  string? Markdown { get; set; }
}


class Document : IMarkdown
{
  [YamlMember(Alias = "title")]
  public string? Title { get; set; }
  [YamlMember(Alias = "description")]
  public string? Description { get; set; }
  public string? Markdown { get; set; }
  public string? Content { get; set; }
  public string? RelativePath { get; set; }
  public string? IconUrl { get; set; }
  public string? Url { get; set; }
}

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

  static IEnumerable<ExternalItem> Transform(IEnumerable<Document> documents)
  {
    return documents.Select(doc =>
    {
      var docId = GetDocId(doc);
      return new ExternalItem
      {
        Id = docId,
        Properties = new()
        {
          AdditionalData = new Dictionary<string, object> {
            // Add properties as defined in the schema in ConnectionConfiguration.cs
            { "title", doc.Title ?? "" },
            { "url", doc.Url ?? "" },
            { "iconUrl", doc.IconUrl ?? "" }
          }
        },
        Content = new()
        {
          Value = doc.Content ?? "",
          Type = ExternalItemContentType.Text
        },
        Acl = new()
        {
          new()
          {
            Type = AclType.Everyone,
            Value = "everyone",
            AccessType = AccessType.Grant
          }
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