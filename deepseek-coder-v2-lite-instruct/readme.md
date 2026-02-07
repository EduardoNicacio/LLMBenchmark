# Model

> [deepseek/deepseek-coder-v2-lite-instruct](https://huggingface.co/lmstudio-community/DeepSeek-Coder-V2-Lite-Instruct-GGUF)

## Summary

We present **DeepSeek-Coder-V2**, an open-source Mixture-of-Experts (MoE) code language model that achieves performance comparable to GPT4-Turbo in code-specific tasks. Specifically, DeepSeek-Coder-V2 is further pre-trained from an intermediate checkpoint of DeepSeek-V2 with additional 6 trillion tokens. Through this continued pre-training, DeepSeek-Coder-V2 substantially enhances the coding and mathematical reasoning capabilities of DeepSeek-V2, while maintaining comparable performance in general language tasks. Compared to DeepSeek-Coder-33B, DeepSeek-Coder-V2 demonstrates significant advancements in various aspects of code-related tasks, as well as reasoning and general capabilities. Additionally, DeepSeek-Coder-V2 expands its support for programming languages from 86 to 338, while extending the context length from 16K to 128K.

In standard benchmark evaluations, DeepSeek-Coder-V2 achieves superior performance compared to closed-source models such as GPT4-Turbo, Claude 3 Opus, and Gemini 1.5 Pro in coding and math benchmarks. The list of supported programming languages can be found at [supported langs](https://github.com/deepseek-ai/DeepSeek-Coder-V2/blob/main/supported_langs.txt).

## Model Inference Parameters

- Temperature: 0.15
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 27/27
- CPU thread pool: 9
- Evaluation batch size: 512
- Max Concurrent Predictions: 4
- RoPE Frequency Base: auto
- RoPE Frequency Scale: auto
- Offload KV cache to GPU memory: on
- Keep model in memory: on
- Try mmap(): on
- Seed: off
- Number of experts: 6
- Force Model Experts Weights onto CPU: off
- Flash attention: off
- K Cache Quantization Type: off
- V Cache Quantization Type: off

## Performance

- Thought for/first token after: 0.2s / 0.2s
- Tokens per second (T-SQL/C#): 101.19 / 146.11

## Observations

- Didn't include input parameter validation (error codes 50001, 50002, 50003) for all the stored procedures as required.
- Used error code 50003 within the try...catch block, which should be used to validate the flag parameters (ActiveFlag, SystemDeleteFlag).
- Didn't follow the instructions to generate production-ready C# code. Here's the message this model provided at the end of the task:

    ```txt
    This setup provides a comprehensive example of how to structure a full-stack .NET application based on the provided SQL table definition, following best practices and including necessary validation and testing. Adjust namespaces and paths according to your project's actual structure.
    ```
