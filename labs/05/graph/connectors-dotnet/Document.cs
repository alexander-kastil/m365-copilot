using YamlDotNet.Serialization;

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
