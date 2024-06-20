using Azure.Identity;
using Microsoft.Graph;
using Microsoft.Extensions.Configuration;

class GraphService
{
  static GraphServiceClient? _client;

  public static GraphServiceClient Client
  {
    get
    {
      if (_client is null)
      {
        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
        IConfigurationRoot configuration = builder.Build();

        var clientId = configuration["client-id"];
        var clientSecret = configuration["client-secret"];
        var tenantId = configuration["tenant-id"];

        var credential = new ClientSecretCredential(tenantId, clientId,    clientSecret);
        _client = new GraphServiceClient(credential);
      }

      return _client;
    }
  }
}
