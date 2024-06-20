using Azure.Identity;
using Microsoft.Extensions.Configuration;

using System.CommandLine;

var provisionConnectionCommand = new Command("provision-connection",    "Provisions external connection");
provisionConnectionCommand.SetHandler(ConnectionService.ProvisionConnection);

var checkConnectionCommand = new Command("check-connection", "Checks external connections");
checkConnectionCommand.SetHandler(ConnectionConfiguration.CheckConnection);

var loadContentCommand = new Command("load-content", "Loads content   into the external connection");
loadContentCommand.SetHandler(ContentService.LoadContent);

var rootCommand = new RootCommand();
rootCommand.AddCommand(provisionConnectionCommand);
rootCommand.AddCommand(loadContentCommand);
rootCommand.AddCommand(checkConnectionCommand);
Environment.Exit(await rootCommand.InvokeAsync(args));