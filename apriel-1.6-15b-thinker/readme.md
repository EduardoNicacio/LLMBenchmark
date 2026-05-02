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

- Context length: 8192
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
- Flash attention: off
- K Cache Quantization Type: off
- V Cache Quantization Type: off

## Performance

- Thought for/first token after: ??? / ???
- Tokens per second (T-SQL/C#): ??? / ???

## Observations

- Differently from other "thinking" or "reasoning" models, it displays its chain of thought directly in the LM Studio chat output.
- It included a nice documentation at the header of each stored procedure, and split them all into separate code blocks as asked.
- It missed some explicit instructions, like not using Update* as input parameters in the retrieve stored procedures.
- On the other hand, it was one of the few models to suggest a cleaner way of handling parameter validation and execution error logging by using a separate stored procedure, called `dbo.RunWithErrorLogging`.
- This model took longer to complete these tasks because it generated two sets of stored procedures, with and without the try...catch block for handling errors on Insert, Update or Select operations.
- The model generated tons of C# code. However, when outputting the latest classes after a long thought, it ran out of context/memory and could not proceed. A 24/32GB video card may help with that.
- The model spent over 2h of GPU time writing C# code and fine-tunning it. I've aborted the execution on the final step, when the model was about to display its final answer. On a second attempt I let the model run loose and, after 4 hours of thinking/planning, it crashed.
