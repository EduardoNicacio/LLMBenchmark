# Model

> [mistralai/codestral-22b-v0.1](https://lmstudio.ai/models/mistralai/codestral-22b-v0.1)

## Summary

Mistral AI's latest coding model, **Codestral** can handle both instructions and code completions with ease in over 80 programming languages.

**Codestral 22B v0.1** is trained on a dataset of 80+ programming languages including of course Python, Java, C++, Javascript, and Bash.

It supports both instruction querying as well as Fill in the Middle querying.

More details and benchmark information can be found on their blogpost here:
[https://mistral.ai/news/codestral/](https://mistral.ai/news/codestral/)

## Model Inference Parameters

- Temperature: 0.1
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 32768
- GPU offload: 56/56
- CPU thread pool: 9
- Evaluation batch size: 512
- Max Concurrent Predictions: 4
- Unified KV Cache: on
- RoPE Frequency Base: auto
- RoPE Frequency Scale: auto
- Offload KV cache to GPU memory: on
- Keep model in memory: on
- Try mmap(): on
- Seed: off
- Flash attention: on
- K Cache Quantization Type: Q8_0
- V Cache Quantization Type: Q8_0

## Performance

- Thought for/time to first token: 14.57s / 0.24
- Tokens per second (T-SQL/C#): 18.91 / 15.02

## Observations

- SQL - Created all the necessary stored procedures as requested, each one in a separate code block.
- .Net/C#: generated the Domain.Entities.Activity class and asked if it should generate the DbContext for the table schema. Then, generated Infrastructure.Data.AppDbContext and asked if it should generate ActivityCreateDto. Then... I guess you already guess how this went...
- Final results: good but slow at creating T-SQL code; terrible and slow at creating .Net/C# code.

### Model closing comments

```md
I have generated the integration tests for your application in the `ActivityIntegrationTests` class. This class contains test methods for testing the activity repository and minimal API endpoints, as well as a Razor Pages page model. The tests cover adding an activity and retrieving it by ID using the activity repository, performing a soft delete, happy-path responses for minimal API endpoints, and populating the list of activities correctly in the Index page model.

I have now generated all fourteen components for your full-stack .Net 8.0 web application as requested. These components include the EF Core entity class, DbContext, data transfer objects (DTOs), view models, generic repository interface and implementation, activity-specific repository interface and implementation, minimal API endpoints, Razor Pages, unit tests, and integration tests. Each component is implemented according to your specifications and follows best practices for .Net 8.0 development.
```
