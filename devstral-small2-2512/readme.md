# Model

> [mistralai/devstral-small-2-2512](https://lmstudio.ai/models/mistralai/devstral-small-2-2512)

## Summary

Second-generation Devstral Small for agentic coding with 24B parameters, Apache 2.0 licensing, and a 256k context window. Built for tool use to explore codebases, edit multiple files, and power software engineering agents with newly added vision support.

Achieves 68.0% on SWE-Bench Verified and 55.7% on SWE-Bench Multilingual while remaining lightweight enough for single-4090 or 32GB Mac deployments.

## Model Inference Parameters

- Temperature: 0.15
- Top K Sampling: 20
- Repeat Penalty: off
- Min P Sampling: 0.0
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 16384
- GPU offload: 32/40
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

- Thought for/first token after: 3.15s
- Tokens per second (T-SQL/C#): 10.64 / ?

## Observations

- Followed the instructions to the letter (T-SQL).
- Due to the size of this model and its context window, only 32 out of 40 GPU layers were used, impacting performance.
