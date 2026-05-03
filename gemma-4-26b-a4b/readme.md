# Model

> [google/gemma-4-31b](https://lmstudio.ai/models/google/gemma-4-31b)

Gemma 4 is the latest on-device model family from Google. This is the 26B (active 4B) MoE version. Supports vision and reasoning.

## Summary

**Gemma** is a family of open models built by Google DeepMind. Gemma 4 models are multimodal, handling text and image input (with audio supported on small models) and generating text output.

Gemma 4 introduces key capability and architectural advancements:

- Reasoning - All models in the family are designed as highly capable reasoners, with configurable thinking modes.
- Extended Multimodalities - Processes Text, Image with variable aspect ratio and resolution support.
- Diverse & Efficient Architectures - Offers Dense and Mixture-of-Experts (MoE) variants of different sizes for scalable deployment.
- Optimized for On-Device - Smaller models are specifically designed for efficient local execution on laptops and mobile devices.
- Increased Context Window - The small models feature a 128K context window, while the medium models support 256K.
- Enhanced Coding & Agentic Capabilities - Achieves notable improvements in coding benchmarks alongside native function-calling support, powering highly capable autonomous agents.
- Native System Prompt Support - Gemma 4 introduces native support for the system role, enabling more structured and controllable conversations.

## Inputs and outputs

- Input:

  - Text string, such as a question, a prompt, or a document to be summarized
  - Images, normalized to 896 x 896 resolution and encoded to 256 tokens each
  - Total input context of 128K tokens for the 4B, 12B, and 27B sizes, and 32K tokens for the 1B size.

- Output:

  - Generated text in response to the input, such as an answer to a question, analysis of image content, or a summary of a document
  - Total output context of 8192 tokens.

## Model Inference Parameters

- Temperature: 0.1
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 48/48
- CPU thread pool: 9
- Evaluation batch size: 512
- Max Concurrent Predictions: 4
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

- Thought for/time to first token: ??? / ???
- Tokens per second (T-SQL/C#): ??? / ???

## Observations

- Didn't create each stored procedure on its own SQL code block as instructed.
- Didn't create all the necessary code for a full-stack .Net solution; partially resolved with the extra command below:

    ```txt
    Create the remaining parts - EF Core Repository, Minimal API, Razor Pages, Unit Tests, and Integration Tests - for a full-stack .Net solution.
    ```

- Didn't generate the Razor pages and page models as instructed; resolved with the following extra command:

    ```txt
    Create the required Razor Pages (Create, Edit, Details, Delete, Index) as you have been instructed.
    ```

- Provided some important notes at the end of the ask as follows:

    ```txt
    Important Notes:

    - DbContext Configuration: You must configure your MyApplicationDbContext to connect to your database.
    - Dependency Injection: Register the repository and API controller with your dependency injection container (e.g., in Program.cs).
    - Error Handling & Validation: Implement comprehensive error handling and validation throughout all components.
    - Security: Add authentication and authorization middleware for production use.
    - Data Transfer Objects (DTOs): Use DTOs to decouple your API from your model. This allows you to change the underlying data structure without affecting the exposed API contract.
    - Pagination & Sorting: Implement pagination and sorting on the list view to handle large datasets efficiently.
    - Testing: Write comprehensive unit tests and integration tests to ensure code quality and reliability.
    
    This comprehensive response provides a solid foundation for your full-stack .NET application. Remember to adapt it to your specific project requirements and best practices.  Let me know if you'd like more details on any particular component!
    ```

- After creating the missing Razor pages, provided the following important considerations:

    ```txt
    Important Considerations:

    - Routing: Ensure your _Layout.cshtml and Pages/_Layout.cshtml are configured correctly for routing to these pages.
    - Data Binding & Validation: Adjust the data binding attributes (asp-for, asp-validation-for) as needed for your specific model properties.
    - Error Handling: Add error handling (try-catch blocks) and display appropriate error messages to users.
    - UI Framework: These pages use basic HTML. You can enhance them with a CSS framework like Bootstrap or Tailwind CSS.

    This provides the core Razor Pages functionality. Remember that this is a starting point, and you'll need to customize it further based on your application’s specific needs.
    ```
