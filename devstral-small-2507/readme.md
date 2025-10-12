# Model

- [mistralai/devstral-small-2507](https://lmstudio.ai/models/mistralai/devstral-small-2507)

## Summary

**Devstral** is MistralAI's latest coding model. It excels at using tools to explore codebases and editing multiple files to power software engineering agents.

The model achieves a score of 53.6% on SWE-Bench Verified, outperforming Devstral Small 2505 by +5.6% and the second best state of the art model by +10.2%.

Despite its compact size of just 24 billion parameters, Devstral outperforms much larger models in agentic coding tasks.

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 36/40
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

- Thought for: 0min5s
- Tokens per second: 10.83

## Observations

- Didn't break the stored procedures into separate code blocks
