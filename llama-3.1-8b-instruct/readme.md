# Model

> [meta-llama/llama-3.1-8b-Instruct](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct)

## Model Information

The Meta **Llama 3.1** collection of multilingual large language models (LLMs) is a collection of pretrained and instruction tuned generative models in 8B, 70B and 405B sizes (text in/text out). The Llama 3.1 instruction tuned text only models (8B, 70B, 405B) are optimized for multilingual dialogue use cases and outperform many of the available open source and closed chat models on common industry benchmarks.

Model Architecture: Llama 3.1 is an auto-regressive language model that uses an optimized transformer architecture. The tuned versions use supervised fine-tuning (SFT) and reinforcement learning with human feedback (RLHF) to align with human preferences for helpfulness and safety.

## Highlights

- Supported languages: English, German, French, Italian, Portuguese, Hindi, Spanish, and Thai.
- Model Release Date: July 23, 2024.
- Model developer: [Meta](https://www.meta.com)

## Model Inference Parameters

- Temperature: 0.8
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 16384
- GPU offload: 32/32
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

- Thought for/first token after: ~0.6s / ~0.4s
- Tokens per second (T-SQL/C#): 94.72 / 96.67

## Observations

- Didn't follow the explicit instruction to create each stored procedure in a separate block of code.
- Didn't add the default schema [dbo] to the stored procedure names.
- Included examples about how to call these stored procedures, as follows:

```sql
-- You can now use these stored procedures in your database
EXEC usp_ActivityInsert
    @ActivityId = NEWID(),
    @ProjectId = '00000000-0000-0000-0000-000000000001',
    @ProjectMemberId = '00000000-0000-0000-0000-000000000002',
    @Name = 'My Activity Name',
    @Description = 'This is my activity description',
    @StartDate = '2022-01-01',
    @TargetDate = '2022-12-31',
    @EndDate = NULL,
    @ProgressStatus = 1,
    @ActivityPoints = 100,
    @Priority = 5,
    @Risk = 3,
    @Tags = 'my_tag',
    @ActiveFlag = 1,
    @CreatedByUser = 'My User Name',
    @CreatedByProgram = 'My Program Name';

EXEC usp_ActivityRetrieve
    @ActivityId = NEWID();

EXEC usp_ActivityUpdate
    @ActivityId = NEWID(),
    @ProjectId = '00000000-0000-0000-0000-000000000001',
    @ProjectMemberId = '00000000-0000-0000-0000-000000000002',
    @Name = 'My Updated Activity Name',
    @Description = 'This is my updated activity description',
    @StartDate = '2023-01-01',
    @TargetDate = '2023-12-31',
    @EndDate = NULL,
    @ProgressStatus = 1,
    @ActivityPoints = 200,
    @Priority = 5,
    @Risk = 3,
    @Tags = 'my_tag',
    @ActiveFlag = 1;

EXEC usp_ActivityDelete
    @ActivityId = NEWID();

EXEC usp_ActivityRetrieveForList;
```
