# Model

- qwen/qwen3-4b-thinking-2507

## Summary

Updated thinking version of Qwen3-4B featuring continued scaling of thinking capability, improving both the quality and depth of reasoning. Qwen3-4B-Thinking-2507 includes the following key enhancements:

Significantly improved performance on reasoning tasks, including logical reasoning, mathematics, science, coding, and academic benchmarks that typically require human expertise. Markedly better general capabilities, such as instruction following, tool usage, text generation, and alignment with human preferences. Enhanced 256K long-context understanding capabilities.

Supports a context length of up to 262,144 tokens.

> Note: This model supports only thinking mode. Specifying enable_thinking=True is not required.

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 36/36
- CPU thread pool: 9
- Evaluation batch size: 512
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

- Thought for: 1min2s
- Tokens per second: 119.09

## Observations

Good performance. Most comprehensive source code.
Along with [qwen3-4b-2507](/qwen3-4b-2507/readme.md), this was the only model to include all the columns with squared brackets, a good practice in MS SQL server.
