# Model

- [qwen/qwen3-4b-2507](https://lmstudio.ai/models/qwen/qwen3-4b-2507)

## Summary

Updated version of Qwen3-4B non-thinking mode featuring significant improvements in general capabilities including instruction following, logical reasoning, text comprehension, mathematics, science, coding and tool usage.

This model delivers substantial gains in long-tail knowledge coverage across multiple languages and markedly better alignment with user preferences in subjective and open-ended tasks, enabling more helpful responses and higher-quality text generation.

Enhanced capabilities in 256K long-context understanding.

> Note: This model supports only non-thinking mode and does not generate `<think></think>` blocks in its output.

## LLM Studio Parameters

- Context length: 32767
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

- Thought for: 0.2s / 0.2s
- Tokens per second: 135.84 / 117.54

## Observations

- Good performance.
- Along with [qwen3-4b-thinking-2507](/qwen3-4b-thinking-2507/readme.md), this was the only model to include all the columns with squared brackets, a good practice in MS SQL server.
- Good quality in general; included appropriate comments for code documentation across the board; only model to generate the Razor pages with Bootstrap tags for the form elements.
- Model appeared to have forgotten to generate the code-behind classes for all the Razor pages.
