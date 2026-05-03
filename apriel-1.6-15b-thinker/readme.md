# Model

> [servicenow-ai/apriel-1.6-15b-thinker](https://huggingface.co/ServiceNow-AI/Apriel-1.6-15b-Thinker)

## Summary

**Apriel-1.6-15B-Thinker** is an updated multimodal reasoning model in ServiceNow’s Apriel SLM series, building on [**Apriel-1.5-15B-Thinker**](https://huggingface.co/ServiceNow-AI/Apriel-1.5-15b-Thinker).

With significantly improved text and image reasoning capabilities, Apriel-1.6 achieves competitive performance against models up to 10x its size.
Like its predecessor, it benefits from extensive continual pre-training across both text and image domains.
We additionally perform post-training that focuses on Supervised Finetuning (SFT) and Reinforcement Learning (RL).
Apriel-1.6 obtains frontier performance without sacrificing reasoning token efficiency.
The model improves or maintains task performance when compared with Apriel-1.5-15B-Thinker, while **reducing reasoning token usage by more than 30\%**.

## Highlights

- Achieves a score of **57** on the Artificial Analysis index outperforming models like Gemini 2.5 Flash, Claude Haiku 4.5 and GPT OSS 20b. It obtains a score on par with Qwen3 235B A22B, while being significantly more efficient.
- **Reduces reasoning token usage by more than 30%**, delivering significantly better efficiency than Apriel-1.5-15B-Thinker.
- Scores **69** on Tau2 Bench Telecom and **69** on IFBench, which are key benchmarks for the enterprise domain.
- At 15B parameters, the model fits on a single GPU, making it highly memory-efficient.
- Based on community feedback on Apriel-1.5-15B-Thinker, we simplified the chat template by removing redundant tags and introduced four special tokens to the tokenizer (`<tool_calls>`, `</tool_calls>`, `[BEGIN FINAL RESPONSE]`, `<|end|>`) for easier output parsing.

Please see our [blog post](https://huggingface.co/blog/ServiceNow-AI/apriel-1p6-15b-thinker) for more details

## Model Inference Parameters

- Temperature: 0.1
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 65536
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

- Thought for/time to first token: 0.08s / 6.04s
- Tokens per second (T-SQL/C#): 33.04 / 29.44

## Observations

- Differently from other "thinking" or "reasoning" models, it displays its chain of thought directly in the LM Studio chat output.
- It included a nice documentation at the header of each stored procedure, and split them all into separate code blocks as asked.
- I remember that, during my code generation tasks with Apriel 1.5, several times the model failed to produce any usable .Net/C# code because it crashed mid chain-of-thought. This appears to be solved for Apriel 1.6.
- The model produced, at a first look, very good quality code that will be tried when I reach the phase of actually executing it.
