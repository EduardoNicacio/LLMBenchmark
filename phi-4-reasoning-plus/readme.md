# Model

- [microsoft/phi-4-reasoning-plus](https://huggingface.co/microsoft/Phi-4-reasoning-plus)

## Summary

Phi-4-reasoning-plus is a state-of-the-art open-weight reasoning model finetuned from Phi-4 using supervised fine-tuning on a dataset of chain-of-thought traces and reinforcement learning. The supervised fine-tuning dataset includes a blend of synthetic prompts and high-quality filtered data from public domain websites, focused on math, science, and coding skills as well as alignment data for safety and Responsible AI. The goal of this approach was to ensure that small capable models were trained with data focused on high quality and advanced reasoning. Phi-4-reasoning-plus has been trained additionally with Reinforcement Learning, hence, it has higher accuracy but generates on average 50% more tokens, thus having higher latency.

## Highlights

- Architecture: Base model same as previously released Phi-4, 14B parameters, dense decoder-only Transformer model
- Inputs: Text, best suited for prompts in the chat format
- Context length: 32k tokens
- Developers: Microsoft Research

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 40/40
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

- Thought for: 9min40s
- Tokens per second: 49.99

## Observations

- Didn't observe the instruction to break the generated stored procedures into separate code blocks, increasing the time spent copying and pasting each one into a separate file.
