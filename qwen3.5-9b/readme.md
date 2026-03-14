# Model

> [qwen/qwen3.5-9b](https://lmstudio.ai/models/qwen/qwen3.5-9b)

## Summary

Qwen3.5 represents a significant leap forward, integrating breakthroughs in multimodal learning, architectural efficiency, reinforcement learning scale, and global accessibility. This is a 9B parameter dense model, supporting a native context length of 262,144 tokens.

## Highlights

**Unified Vision-Language Foundation**. Early fusion training on multimodal tokens achieves cross-generational parity with Qwen3 and outperforms Qwen3-VL models across reasoning, coding, agents, and visual understanding benchmarks.

**Scalable RL Generalization**. Reinforcement learning scaled across million-agent environments with progressively complex task distributions for robust real-world adaptability.

**Global Linguistic Coverage**. Expanded support to 201 languages and dialects, enabling inclusive, worldwide deployment with nuanced cultural and regional understanding.

## Model Inference Parameters

- Thinking: enabled
- Temperature: 1.0
- Top K Sampling: 20
- Repeat Penalty: off
- Min P Sampling: 0.0
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 65535
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

- Thought for/first token after: 1min57s / 47s
- Tokens per second (T-SQL/C#): 61.17 / 60.52

## Observations

- Good performance. Source-code is easy to follow and understand.
- Along with other Qwen models and [openai/gpt-oss-20b](https://lmstudio.ai/models/openai/gpt-oss-20b), this model also wrapped all the names of the table columns with squared brackets, a good practice in MS SQL server.
- Produced a nice summary of best practices applied, as follows:

---

### Summary of Best Practices Applied

1. Separation of Concerns: Models represent the DB, DTOs represent API contracts, ViewModels represent UI state.
2. Validation: Data annotations ([Required], [MaxLength]) are used on DTOs and ViewModels.
3. Soft Delete: SystemDeleteFlag is handled in the Repository to ensure deleted records are not returned by default.
4. Audit Fields: CreatedDateTime and UpdatedDateTime are managed in the Repository to ensure consistency.
5. Dependency Injection: Repositories are injected into API and Page Models.
6. Testing: Unit tests verify logic and data structures; Integration tests verify repository behavior and API endpoint registration.
7. Security: Sensitive fields (like CreatedByProgram) are included in the Model but can be excluded from DTOs if necessary for security.
8. Production Ready: Includes error handling (NotFound), async/await patterns, and proper disposal of resources.

---
