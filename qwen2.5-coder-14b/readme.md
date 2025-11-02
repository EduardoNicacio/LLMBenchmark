# Model

> [qwen/qwen2.5-coder-14b](https://lmstudio.ai/models/qwen/qwen2.5-coder-14b)

## Summary

Qwen2.5-Coder is the latest series of Code-Specific Qwen large language models (formerly known as CodeQwen). As of now, Qwen2.5-Coder has covered six mainstream model sizes, 0.5, 1.5, 3, 7, 14, 32 billion parameters, to meet the needs of different developers. Qwen2.5-Coder brings the following improvements upon CodeQwen1.5:

- Significantly improvements in code generation, code reasoning and code fixing. Base on the strong Qwen2.5, we scale up the training tokens into 5.5 trillion including source code, text-code grounding, Synthetic data, etc. Qwen2.5-Coder-32B has become the current state-of-the-art open-source codeLLM, with its coding abilities matching those of GPT-4o.
- A more comprehensive foundation for real-world applications such as Code Agents. Not only enhancing coding capabilities but also maintaining its strengths in mathematics and general competencies.
- Long-context support up to 128K tokens.

## Highlights

This repo contains the instruction-tuned 14B Qwen2.5-Coder model in the GGUF Format, which has the following features:

- Type: Causal Language Models
- Training Stage: Pretraining & Post-training
- Architecture: transformers with RoPE, SwiGLU, RMSNorm, and Attention QKV bias
- Number of Parameters: 14.7B
- Number of Paramaters (Non-Embedding): 13.1B
- Number of Layers: 48
- Number of Attention Heads (GQA): 40 for Q and 8 for KV
- Context Length: Full 32,768 tokens
- Note: Currently, only vLLM supports YARN for length extrapolating. If you want to process sequences up to 131,072 tokens, please refer to non-GGUF models.
- Quantization: q2_K, q3_K_M, q4_0, **q4_K_M**, q5_0, q5_K_M, q6_K, q8_0

## Model Inference Parameters

- Temperature: 0.5
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 16384
- GPU offload: 48/48
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

- Thought for: 0min1s
- Tokens per second: 54.51

## Observations

- Same output quality of qwen3-4b-2507, but almost three times slower.
- Didn't create each stored procued into a single code block as requested.
- I needed to manually request the code generation for some missing pages (`Edit`, `Details`, `Delete`, and `Index`), as well as the missing repository methods `GetByIdAsync()`, `AddAsync()`, `Update()` and `Delete()` as defined in the interface IGenericRepository. Not all the methods defined in this interface have been implemented in the (`IQueryable<T> GetAll()` vs `Task<List<ReadActivityDto>> GetAllAsync()`).
