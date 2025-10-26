# Model

> [mistralai/devstral-small-2507](https://lmstudio.ai/models/mistralai/devstral-small-2507)

## Summary

**Devstral** is MistralAI's latest coding model. It excels at using tools to explore codebases and editing multiple files to power software engineering agents.

The model achieves a score of 53.6% on SWE-Bench Verified, outperforming Devstral Small 2505 by +5.6% and the second best state of the art model by +10.2%.

Despite its compact size of just 24 billion parameters, Devstral outperforms much larger models in agentic coding tasks.

## LLM Studio Parameters

- Context length: 4096
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

- Thought for: 5s / 3s
- Tokens per second: 38.25 / 38.17

## Observations

- Didn't break each stored procedure into a separate code block for easy copy and paste. Resolved with the extra command below:

    ```txt
    Split each stored procedure above into its corresponding SQL code block.
    ```

- Included an extra utility function to validate input parameters, and an extra stored procedure to store the execution errors. Nice. :-)
- Didn't generate a complete, production-ready C# code. Ended up with the message below:

    ```txt
    This completes the full-stack .NET application components for the Activity table. Each component is designed following best practices and includes proper validation and testing mechanisms.
    ```
