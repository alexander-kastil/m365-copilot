# Semantic Kernel

- Understand the purpose of Semantic Kernel
- Understand prompting basics & techniques for more effective prompts
- Implementing Agent Personas
- Use OpenAI, Azure OpenAI & 3rd party Large Language Models

## Create a Semantic Kernel

```c#
var kernelBuilder = Kernel.CreateBuilder();
if (useLocal != "true")
{
    // Azure OpenAI
    var model = configuration["SemanticKernel:DeploymentModel"];
    var endpoint = configuration["SemanticKernel:Endpoint"];
    var resourceKey = configuration["SemanticKernel:ApiKey"];
    
    kernelBuilder.Services.AddAzureOpenAIChatCompletion(
    model,
    endpoint,
    resourceKey
);
}
else
{
    // Local LLM
    var localEndpoint = configuration["LocalModelSettings:Endpoint"];
    var url = $"{localEndpoint}/v1/chat/completions";
    HttpClient client = new(new LocalServerClientHandler(url));
    
    kernelBuilder.AddOpenAIChatCompletion("local-model", url, "not required", httpClient: client);
}

var kernel = kernelBuilder.Build();
```