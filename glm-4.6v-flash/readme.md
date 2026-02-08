# Model

> [zai-org/glm-4.6v-flash](https://lmstudio.ai/models/zai-org/glm-4.6v-flash)

## Summary

GLM 4.6V Flash is a 9B vision-language model optimized for local deployment and low-latency applications. It supports a context length of 128k tokens and achieves strong performance in visual understanding among models of similar scale.

The model introduces native multimodal function calling, enabling vision-driven tool use where images, screenshots, and document pages can be passed directly as tool inputs without text conversion.

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

- Thought for/first token after: 2min43s / 5min36s
- Tokens per second (T-SQL/C#): 61.12 / 35.50

## Observations

- The whole `thinking` process of this model happened in Chinese, making it impossible to follow as I'm not a Chinese speaker.
- Didn't provide each SQL statement into a separate block, making it hard to copy and paste each stored procedure. At least the code follows the standards observed in other models.
- Similarly to the model qwen3-VL-8b, didn't create the Razor pages as intructed; only the code-behind has been created. Also, no ViewModel has been created at all.
