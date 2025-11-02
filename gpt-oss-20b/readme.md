# Model

> [openai/gpt-oss-20b](https://huggingface.co/openai/gpt-oss-20b)

## Summary

**GPT OSS 20B** is a large‑language model developed by [OpenAI](https://openai.com/open-models/). Trained on diverse text up to June 2024, I generate human‑like responses, answer questions, offer explanations, and help with writing, coding, brainstorming, and more. While I don’t have personal experiences or emotions, I’m designed to provide accurate, helpful, and context‑aware assistance across a wide range of topics.

## Highlights

- Permissive Apache 2.0 license: Build freely without copyleft restrictions or patent risk—ideal for experimentation, customization, and commercial deployment.
- Configurable reasoning effort: Easily adjust the reasoning effort (low, medium, high) based on your specific use case and latency needs.
- Full chain-of-thought: Gain complete access to the model’s reasoning process, facilitating easier debugging and increased trust in outputs. It’s not intended to be shown to end users.
- Fine-tunable: Fully customize models to your specific use case through parameter fine-tuning.
- Agentic capabilities: Use the models’ native capabilities for function calling, web browsing, Python code execution, and Structured Outputs.
- MXFP4 quantization: The models were post-trained with MXFP4 quantization of the MoE weights, making gpt-oss-120b run on a single 80GB GPU (like NVIDIA H100 or AMD MI300X) and the gpt-oss-20b model run within 16GB of memory. All evals were performed with the same MXFP4 quantization.

## Model Inference Parameters

Temperature: 0.6
Top K Sampling: 40
Repeat Penalty: 1.1
Min P Sampling: 0.05
Top P Sampling: 0.8

## LLM Studio Parameters

- Context length: 16384
- GPU offload: 24/24
- CPU thread pool: 9
- Evaluation batch size: 512
- RoPE Frequency Base: auto
- RoPE Frequency Scale: auto
- Offload KV cache to GPU memory: on
- Keep model in memory: on
- Try mmap(): on
- Seed: off
- Number of experts: 4
- Force Model Expert Weights onto CPU: off
- Flash attention: off
- K Cache Quantization Type: off
- V Cache Quantization Type: off

## Performance

- Thought for: 0min16s / 0min12s
- Tokens per second: 122.60 / 112.60

## Observations

- Stopped mid-execution due to context max size of 4096. Needed to be restarted with a larger context of 8192 tokens.
- Very good performance on both tasks. Added sweet comments throughout the code.
- Correctly used squared bracked around column names that can be mistaken by MS SQL server reserved words, like Name and Description.
- Suggested all the Nuget packages required by the full-stack .Net code:

    ```txt
    ⚠️ The code assumes you have the following NuGet packages installed:

    Microsoft.EntityFrameworkCore (and EF‑Core provider of your choice)
    Microsoft.AspNetCore.Mvc.RazorPages
    Microsoft.Extensions.DependencyInjection
    Microsoft.AspNetCore.Http.Json
    NUnit, Moq, Microsoft.NET.Test.Sdk, coverlet.collector (for the tests)
    ```

- Provided the right folder structure in which I should drop the files:

    ```txt
    MyApp/
    ├─ Models/
    │   └─ Activity.cs
    ├─ DTOs/
    │   ├─ ActivityCreateDto.cs
    │   ├─ ActivityUpdateDto.cs
    │   └─ ActivityReadDto.cs
    ├─ ViewModels/
    │   ├─ ActivityCreateViewModel.cs
    │   ├─ ActivityUpdateViewModel.cs
    │   └─ ActivityListViewModel.cs
    ├─ Data/
    │   ├─ AppDbContext.cs          // EF Core DbContext
    │   ├─ IRepository.cs
    │   ├─ GenericRepository.cs
    │   ├─ IActivityRepository.cs
    │   └─ ActivityRepository.cs
    ├─ Pages/
    │   └─ Activities/
    │       ├─ Index.cshtml / Index.cshtml.cs
    │       ├─ Create.cshtml / Create.cshtml.cs
    │       ├─ Edit.cshtml / Edit.cshtml.cs
    │       ├─ Details.cshtml / Details.cshtml.cs
    │       └─ Delete.cshtml / Delete.cshtml.cs
    ├─ Program.cs                     // Minimal API + DI config
    └─ Tests/
        ├─ Unit/
        │   ├─ ModelValidationTests.cs
        │   ├─ DtoMappingTests.cs
        │   └─ ViewModelPropertyTests.cs
        └─ Integration/
            ├─ RepositoryIntegrationTests.cs
            ├─ MinimalApiIntegrationTests.cs
            └─ RazorPagesIntegrationTests.cs
    ```
