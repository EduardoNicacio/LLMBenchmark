# Model

> [mistralai/ministral-3-14b-reasoning](https://lmstudio.ai/models/mistralai/ministral-3-14b-reasoning)

## Summary

The reasoning post-trained version of Ministral 3 14B, optimized for complex reasoning tasks.

- Supports context length of 256k tokens.
- Excels at complex, multi-step reasoning and dynamic problem-solving, making it ideal for math, coding, and STEM-related use cases.
- Vision-enabled for image analysis and multimodal reasoning tasks.
- Multilingual support across dozens of languages including English, French, Spanish, German, Italian, Portuguese, Dutch, Chinese, Japanese, Korean, Arabic.
- Native function calling and JSON output generation with best-in-class agentic capabilities.
- Edge-optimized for deployment on a wide range of hardware including local devices.

Apache 2.0 License

## Model Inference Parameters

- Temperature: 0.15
- Top K Sampling: 20
- Repeat Penalty: off
- Min P Sampling: 0.0
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 32768
- GPU offload: 36/36
- CPU thread pool: 9
- Evaluation batch size: 512
- Max Concurrent Predictions: 4
- RoPE Frequency Base: auto
- RoPE Frequency Scale: auto
- Offload KV cache to GPU memory: on
- Keep model in memory: on
- Try mmap(): on
- Seed: off
- Flash attention: off
- K Cache Quantization Type: off
- V Cache Quantization Type: off

## Performance

- Thought for/first token after: 2min41s / 3min7s
- Tokens per second (T-SQL/C#): 52.31 / ?

## Observations

- Followed the instructions to the letter (T-SQL), creating each stored procedure in a separate code block, including all the specified validations.
- Assumed [dbo] ad the default schema in which the stored procedures should be created. Also, correctly used `CREATE OR ALTER PROCEDURE...` instead of just `CREATE PROCEDURE...`, which can cause errors if these stored procedures already exist.
- Followed the instructions to the letter (C#), but the code generation failed when creating the Razor pages due to a context overflow. The produced code looks promising, though.
