# Model

> [cohere/command-a-reasoning-08-2025](https://docs.cohere.com/v2/docs/command-a-reasoning)

## Summary

Command A Reasoning is Cohere’s first reasoning model to date, excelling at real world enterprise tasks including tool use, retrieval augmented generation (RAG), agents, and multilingual use cases. At 111B parameters, Command A has a context length of 256K. Command-a-Reasoning (CAR) is optimized to run on 4x H100 GPUs for production workloads. For non-production tasks such as tryouts and evaluations, it can also run on 4x A100 GPUs.

### What Can Command A Reasoning Be Used For?

Command A is excellent for:

- **Agentic Use Cases**: Taking autonomous actions and interacting with the environment to solve problems.
- **Tool Use**: Able to leverage a variety of tools, such as search engines and APIs.
- **Multilingual**: Able to reason over multilingual inputs, providing support to user queries in 23 different languages.

There’s more to be said about token budgets, enabling and disabling the `thinking` operation, etc., which can be found in our dedicated [Reasoning guide](https://docs.cohere.com/v2/docs/reasoning).

## Model Inference Parameters

- Temperature: 0.1
- Top K Sampling: n/a
- Repeat Penalty: n/a
- Min P Sampling: n/a
- Top P Sampling: n/a

## LLM Studio Parameters

- N/A (this is an online tool)

## Performance

- N/A (this is an online tool)

## Observations

- Performed way better with the new optimized prompts for both T-SQL and C#/.Net coding tasks.
- Produced code blocks without a single lint error (VS Code) as far as I can see; this code will be validated when I start building .Net Web apps based on it.
