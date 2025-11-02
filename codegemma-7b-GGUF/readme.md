# Model

> [google/codegemma-7b](https://huggingface.co/google/codegemma-7b)

## Summary

**CodeGemma** is a collection of lightweight open code models built on top of Gemma. CodeGemma models are text-to-text and text-to-code decoder-only models and are available as a 7 billion pretrained variant that specializes in code completion and code generation tasks, a 7 billion parameter instruction-tuned variant for code chat and instruction following and a 2 billion parameter pretrained variant for fast code completion.

| | codegemma-2b | codegemma-7b | codegemma-7b-it |
| :--- | :--: | :--: | :--: |
| Code Completion | ✅ | ✅ | |
| Generation from natural language | | ✅ | ✅ |
| Chat | | | ✅ |
| Instruction Following | | | ✅ |

## Sample Usage

This model is intended to answer questions about code fragments, to generate code from natural language, or to engage in a conversation with the user about programming or technical problems. If you need to use code completion (for example, integrated in an IDE), we recommend you use one of the pre-trained models instead: [CodeGemma 7B](https://huggingface.co/google/codegemma-7b), or [CodeGemma 2B](https://huggingface.co/google/codegemma-2b).

### For Code Completion

Code completion can be used for infilling inside code editors. CodeGemma was trained for this task using the fill-in-the-middle (FIM) objective, where you provide a prefix and a suffix as context for the completion. The following tokens are used to separate the different parts of the input:

- <|fim_prefix|> precedes the context before the completion we want to run.
- <|fim_suffix|> precedes the suffix. You must put this token exactly where the cursor would be positioned in an editor, as this is the location that will be completed by the model.
- <|fim_middle|> is the prompt that invites the model to run the generation.

In addition to these, there's also <|file_separator|>, which is used to provide multi-file contexts.

Please, make sure to not provide any extra spaces or newlines around the tokens, other than those that would naturally occur in the code fragment you want to complete.

## Model Inference Parameters

- Temperature: 0.8
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 28/28
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

- Thought for/first token after: ???
- Tokens per second (T-SQL/C#): ???

## Observations

- Strange results, like the model not generating anything at 153,846 tokens per second; or hallucinating by affirming that using python with an ORM would be better than running the requested stored procedures.
- Other times, the model generates garbage like below until it crashes:

    ```sql
    -- usp_ActivityInsert 501f84e3-736d - d9a2bcbecfbdbfaeabebbdcfdcabdcfe -- Description: Insert new Activity record. Input parameters include all columns except UpdatedDateTime, Updat eedByUser ,UpdatedByProgram and SystemTimestamp . Explicitly specify CreatedDateTim
    -- usp_ActivityDelete 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Delete existing Activity record. Input parameters include all columns except UpdatedDateTime, Updat eedByUser ,UpdatedByProgram and SystemTimestamp . Soft delete by setting Syst
    -- usp_ActivityUpdate 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Update existing Activity record. Input parameters include all columns except CreatedDateTime, Cr eatedByUser ,CreatedByProgram .
    -- usp_ActivityRetrieve 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Retrieve existing Activity record. Input parameters include all columns except Updat edDateTim e, UpdatedByUser ,UpdatedByProgram .
    -- usp_ActivityRetrieveForList 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Retrieve Activity record for list. Input parameters include all columns except Updat edDateTim e, UpdatedByUser ,UpdatedByProgram .
    ```
