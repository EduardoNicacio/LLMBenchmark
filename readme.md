# Small / Medium Local LLM Comparison

## Abstract

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel enim diam. Sed sollicitudin condimentum risus ut semper. Praesent pulvinar mauris quis aliquam tincidunt. Nullam vitae nulla sed lectus pharetra condimentum imperdiet ut mauris. Fusce sem neque, blandit a diam laoreet, auctor ornare odio. Donec viverra sapien nec mi tempus commodo. Vestibulum in tortor laoreet, porta ipsum sit amet, iaculis ligula. Sed hendrerit dui quis consectetur pharetra. Donec imperdiet consequat nisl, fringilla molestie arcu consectetur eget. Nullam cursus nec velit eget maximus.

Donec et interdum neque, quis efficitur ipsum. Vestibulum hendrerit a dolor ut bibendum. Vivamus tincidunt commodo erat sit amet condimentum. Sed at dolor et enim tristique dictum vel quis felis. Nam euismod mauris at dui laoreet tempus. Etiam sit amet lacinia felis. Sed vel sollicitudin sapien. Nullam est metus, faucibus vitae lacus in, elementum euismod ligula. Phasellus maximus tortor a iaculis dignissim. Morbi id finibus massa. Donec et lobortis quam, vel blandit diam. Ut quis accumsan urna.

Morbi tincidunt nibh vitae nibh sodales suscipit. Donec vitae lobortis quam, ac mollis tellus. Aliquam erat volutpat. Ut convallis maximus tellus, id interdum diam pretium tempus. Praesent ac mattis leo. Sed pretium est nec turpis fringilla varius a vel nunc. Morbi vehicula nulla arcu, non finibus nisl malesuada non. Nunc in hendrerit mauris. Proin nec cursus ligula, quis venenatis dolor. Integer nunc metus, vestibulum non aliquet eget, ultricies at lorem.

## Methodology

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel enim diam. Sed sollicitudin condimentum risus ut semper. Praesent pulvinar mauris quis aliquam tincidunt. Nullam vitae nulla sed lectus pharetra condimentum imperdiet ut mauris. Fusce sem neque, blandit a diam laoreet, auctor ornare odio. Donec viverra sapien nec mi tempus commodo. Vestibulum in tortor laoreet, porta ipsum sit amet, iaculis ligula. Sed hendrerit dui quis consectetur pharetra. Donec imperdiet consequat nisl, fringilla molestie arcu consectetur eget. Nullam cursus nec velit eget maximus. Cras convallis lorem urna, vel dictum purus ultrices aliquam. Curabitur scelerisque sit amet mauris non vulputate.

Donec et interdum neque, quis efficitur ipsum. Vestibulum hendrerit a dolor ut bibendum. Vivamus tincidunt commodo erat sit amet condimentum. Sed at dolor et enim tristique dictum vel quis felis. Nam euismod mauris at dui laoreet tempus. Etiam sit amet lacinia felis. Sed vel sollicitudin sapien. Nullam est metus, faucibus vitae lacus in, elementum euismod ligula. Phasellus maximus tortor a iaculis dignissim. Morbi id finibus massa. Donec et lobortis quam, vel blandit diam. Ut quis accumsan urna.

## Target Large Language Models - LLMs

- [cohere/command-a-03-2025](/command-a-03-2025/readme.md) - Online model
- [deepseek/deepseek-coder-v2-lite-instruct](/deepseek-coder-v2-lite-instruct/readme.md)
- [google/gemma-3-12b](/gemma-3-12b/readme.md)
- [google/codegemma-7b](/codegemma-7b-GGUF/readme.md)
- [ibm/granite-4-h-tiny](/granite-4-h-tiny/readme.md)
- [meta-ai/llama-3.1-8b-instruct](/llama-3.1-8b-instruct/readme.md)
- [mistralai/codestral-22b-v01](/codestral-22b-v0.1/readme.md)
- [mistralai/devstral-small-2507](/devstral-small-2507/readme.md)
- [microsoft/phi-4-reasoning-plus](/phi-4-reasoning-plus/readme.md)
- [openai/gpt-oss-20b](/gpt-oss-20b/readme.md)
- [qwen/qwen2.5-coder-14b](/qwen2.5-coder-14b/readme.md)
- [qwen/qwen3-4b-2507](/qwen3-4b-2507/readme.md)
- [qwen/qwen3-4b-thinking-2507](/qwen3-4b-thinking-2507/readme.md)
- [servicenow-ai/apriel-1.5-15b-thinker](/apriel-1.5-15b-thinker/readme.md)

## Platform

- [Gigabyte Aorus B550 Elite AX V2](https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-AX-V2-rev-10)
- [AMD Ryzen 9 5900X (12c/24t) @4.7GHz](https://www.amd.com/en/products/processors/desktops/ryzen/5000-series/amd-ryzen-9-5900x.html)
- [G.Skill F4-3200C16D-32GVK](https://www.gskill.com/product/165/184/1536110922/F4-3200C16D-32GVK)
- [Crucial P5 Plus 1TB Gen4 NVMe M.2 SSD](https://www.crucial.com/ssd/p5-plus/ct1000p5pssd5)
- [Sapphire PURE AMD Radeon™ RX 9070 XT](https://www.sapphiretech.com/en/consumer/pure-radeon-rx-9070-xt-16g-gddr6)
- [Microsoft Windows 11 Professional 24-H2 (OS build 26200.6725)](https://www.microsoft.com/en-ca/windows/windows-11)
- [LM Studio 0.3.28](https://lmstudio.ai/)
- [llama.cpp Vulkan Windows v1.52.1](https://github.com/ggml-org/llama.cpp)

## T-SQL Generation (MS SQL Server 2022)

Below is the full prompt as used for all the models (including Cohere Command):

---

Task:

Generate SQL stored procedures for the Activity table based on the following requirements. Use T-SQL syntax and ensure the code is production-ready.

Table Definition:

```sql
CREATE TABLE [dbo].[Activity](
    [ActivityId] [uniqueidentifier] NOT NULL,
    [ProjectId] [uniqueidentifier] NOT NULL,
    [ProjectMemberId] [uniqueidentifier] NOT NULL,
    [Name] [nvarchar](128) NOT NULL,
    [Description] [nvarchar](4000) NOT NULL,
    [StartDate] [date] NULL,
    [TargetDate] [date] NULL,
    [EndDate] [date] NULL,
    [ProgressStatus] [tinyint] NULL,
    [ActivityPoints] [smallint] NULL,
    [Priority] [tinyint] NULL,
    [Risk] [tinyint] NULL,
    [Tags] [nvarchar](200) NULL,
    [ActiveFlag] [tinyint] NOT NULL,
    [SystemDeleteFlag] [char](1) NOT NULL,
    [CreatedDateTime] [datetime2](7) NOT NULL,
    [CreatedByUser] [nvarchar](100) NOT NULL,
    [CreatedByProgram] [nvarchar](100) NOT NULL,
    [UpdatedDateTime] [datetime2](7) NULL,
    [UpdatedByUser] [nvarchar](100) NULL,
    [UpdatedByProgram] [nvarchar](100) NULL,
    [SystemTimestamp] [timestamp] NOT NULL,
    CONSTRAINT [PK_Activity_ActivityId] PRIMARY KEY CLUSTERED ([ActivityId] ASC)
) ON [PRIMARY];
GO
```

Stored Procedures to Create:

`usp_ActivityInsert`:

- Input parameters: All columns except UpdatedDateTime, UpdatedByUser, UpdatedByProgram, and SystemTimestamp.
- Explicitly include CreatedDateTime, CreatedByUser, and CreatedByProgram as input parameters.
- Default nullable columns to NULL.

`usp_ActivityDelete`:

- Input parameters: ActivityId, UpdatedDateTime, UpdatedByUser, UpdatedByProgram, and SystemTimestamp.
- Soft-delete by setting SystemDeleteFlag = 'Y'.
- Default UpdatedDateTime, UpdatedByUser, and UpdatedByProgram to SYSUTCDATETIME(), SYSTEM_USER, and APP_NAME() if null.
- Use SystemTimestamp for optimistic locking.

`usp_ActivityUpdate`:

- Input parameters: All columns except CreatedDateTime, CreatedByUser, and CreatedByProgram.
- Default UpdatedDateTime, UpdatedByUser, and UpdatedByProgram to SYSUTCDATETIME(), SYSTEM_USER, and APP_NAME() if null.
- Use SystemTimestamp for optimistic locking.

`usp_ActivityRetrieve`:

- Input parameters: All columns (defaulted to NULL), except UpdatedDateTime, UpdatedByUser, and UpdatedByProgram.
- Default ActiveFlag to 1 and SystemDeleteFlag to 'N'.
- Use wildcard search for varchar and nvarchar columns:

    `(@Parameter IS NULL OR CHARINDEX(@Parameter, [Column], 0) > 0)`

- Use date range search for date columns:

    `(@DateTimeParameter IS NULL OR DateTimeColumn >= @DateTimeParameter AND DateTimeColumn < DATEADD(day, 1, @DateTimeParameter))`

`usp_ActivityRetrieveForList`:

- Retrieve ActivityId and Name for active, non-deleted records (ActiveFlag = 1 and SystemDeleteFlag <> 'Y').

General Requirements for All Stored Procedures:

- Validate input parameters for type, size, and nullability.
- Raise error 50001 for null parameters.
- Raise error 50002 for string parameters exceeding column length.
- Raise error 50003 for invalid ActiveFlag (must be 0 or 1) or SystemDeleteFlag (must be 'N' or 'Y').
- Wrap SELECT, INSERT, and UPDATE statements in a TRY...CATCH block.
- Log errors to dbo.DbError table in the CATCH block.
- Raise error 50000 with message: "Error occurred during [Operation] operation."
- For optimistic lock violations, raise error 50004 with message:

    `"Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again."`

- Enclose each stored procedure in a separate SQL code block.

Output Format:

Provide each stored procedure in a separate code block, fully functional and ready to execute.

---

## C# Model Generation

```txt
TBD
```

## C# DTO Generation

```txt
TBD
```

## C# ViewModel Generation

```txt
TBD
```

## C# Repository Generation

```txt
TBD
```

## Asp.Net Core Minimal API Generation

```txt
TBD
```

## Asp.Net Core Razor Pages Generation

```txt
TBD
```

## Unit Tests Generation (with NUnit)

```txt
TBD
```

## Integrated Tests Generation (With Moq)

```txt
TBD
```

## Results

[placeholder]

### T-SQL Generation

[placeholder]

### C# Models

[placeholder]

### C# DTOs

[placeholder]

### C# ViewModels

[placeholder]

### C# Repositories

[placeholder]

### Asp.Net Core Minimal APIs

[placeholder]

### Asp.Net Core Razor Page(s)

[placeholder]

### Unit Tests results

[placeholder]

### Integration Tests results

[placeholder]

## Comments

When it comes to run LLMs locally, choosing the right model for a given task is probably one of the most important decisions one can make. While some models are simply brilliant at coding tasks, other can't complete the tasks even when explicitly instructed about what to do.

[placeholder]

With all that said, choosing the right model for the tasks above allowed me to refactor an old Asp.Net project of mine as follows:

- Data layer: 20h (SQL Server 2022 db with 67 tables and 146 stored procedures, totaling 17,000 lines of code).
- C# Models:
- C# DTOs:
- C# ViewModels:
- C# Repositories:
- Asp.Net Core Minimal Api:
- Asp.Net Code Razor pages:
- Unit tests: [n] unit tests have been created, with a total code coverage of [nn]%.
- Integration tests: [n] integrated tests have been created, with a total coverage of [nn]%.

## Useful links

- [LM Studio](https://lmstudio.ai/)
- [llama.cpp](https://github.com/ggml-org/llama.cpp)
- [Hugging Face](https://huggingface.co/)
- [Lorem Ipsum generator](https://www.lipsum.com/feed/html)
- [Microsoft Visual Studio Code](https://code.visualstudio.com/)
- [Microsoft Visual Studio](https://visualstudio.microsoft.com/vs/)
- [Microsoft SQL Server 2022](https://www.microsoft.com/en-ca/sql-server/sql-server-2022)

Found these findings useful? Leave a star. :-)
