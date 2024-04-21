using System;
using System.Collections.Generic;
using Microsoft.Identity.Client;
using Microsoft.Graph;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace GraphConsole
{
    class Program
    {
        private static GraphServiceClient _graphClient;

        static void Main(string[] args)
        {
            var config = LoadAppSettings();
            if (config == null)
            {
            Console.WriteLine("Invalid appsettings.json file.");
            return;
            }

            var graph = GetAuthenticatedGraphClient(config);
            var user = "alexander.pajer@integrations.at";

            //Upload small file
            var smallFile = "smallfile.txt";
            var smallPath = Path.Combine(System.IO.Directory.GetCurrentDirectory(), smallFile);
            Console.WriteLine("Uploading file: " + smallFile);

            FileStream fileStream = new FileStream(smallPath, FileMode.Open);
            var uploadedFile = graph.Users[user].Drive.Root
                                        .ItemWithPath("smallfile.txt")
                                        .Content
                                        .Request()
                                        .PutAsync<DriveItem>(fileStream)
                                        .Result;
            Console.WriteLine("File uploaded to: " + uploadedFile.WebUrl);

            //Upload large file
            var largeFile = "dogs.zip";
            var largePath = Path.Combine(System.IO.Directory.GetCurrentDirectory(), largeFile);
            Console.WriteLine("Uploading file: " + largeFile);

            using (Stream stream = new FileStream(largePath, FileMode.Open))
            {
                var uploadSession = graph.Users[user].Drive.Root
                                                .ItemWithPath(largeFile)
                                                .CreateUploadSession()
                                                .Request()
                                                .PostAsync()
                                                .Result;

                // create upload task
                var maxChunkSize = 320 * 1024;
                var largeUploadTask = new LargeFileUploadTask<DriveItem>(uploadSession, stream, maxChunkSize);

                // create progress implementation
                IProgress<long> uploadProgress = new Progress<long>(uploadBytes =>
                {
                    Console.WriteLine($"Uploaded {uploadBytes} bytes of {stream.Length} bytes");
                });

                // upload file
                UploadResult<DriveItem> uploadResult = largeUploadTask.UploadAsync(uploadProgress).Result;
                if (uploadResult.UploadSucceeded)
                {
                    Console.WriteLine("File uploaded to user's OneDrive root folder.");
                }
            }
            
        }

        private static IConfigurationRoot LoadAppSettings()
        {
            try
            {
                var config = new ConfigurationBuilder()
                                .SetBasePath(System.IO.Directory.GetCurrentDirectory())
                                .AddJsonFile("appsettings.json", false, true)
                                .Build();

                if (string.IsNullOrEmpty(config["applicationId"]) ||
                    string.IsNullOrEmpty(config["applicationSecret"]) ||
                    string.IsNullOrEmpty(config["redirectUri"]) ||
                    string.IsNullOrEmpty(config["tenantId"]))
                {
                return null;
                }

                return config; 
            }
            catch (System.IO.FileNotFoundException)
            {
                return null;
            }
        }

        private static IAuthenticationProvider CreateAuthorizationProvider(IConfigurationRoot config)
        {
            var clientId = config["applicationId"];
            var clientSecret = config["applicationSecret"];
            var redirectUri = config["redirectUri"];
            var authority = $"https://login.microsoftonline.com/{config["tenantId"]}/v2.0";

            List<string> scopes = new List<string>();
            scopes.Add("https://graph.microsoft.com/.default");

            var cca = ConfidentialClientApplicationBuilder.Create(clientId)
                                                    .WithAuthority(authority)
                                                    .WithRedirectUri(redirectUri)
                                                    .WithClientSecret(clientSecret)
                                                    .Build();
            return new MsalAuthenticationProvider(cca, scopes.ToArray());
        }

        private static GraphServiceClient GetAuthenticatedGraphClient(IConfigurationRoot config)
        {
            var authenticationProvider = CreateAuthorizationProvider(config);
            _graphClient = new GraphServiceClient(authenticationProvider);
            return _graphClient;
        }
    }
}
