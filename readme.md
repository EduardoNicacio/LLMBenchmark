# Small / Medium Local LLM Comparison

## Abstract

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel enim diam. Sed sollicitudin condimentum risus ut semper. Praesent pulvinar mauris quis aliquam tincidunt. Nullam vitae nulla sed lectus pharetra condimentum imperdiet ut mauris. Fusce sem neque, blandit a diam laoreet, auctor ornare odio. Donec viverra sapien nec mi tempus commodo. Vestibulum in tortor laoreet, porta ipsum sit amet, iaculis ligula. Sed hendrerit dui quis consectetur pharetra. Donec imperdiet consequat nisl, fringilla molestie arcu consectetur eget. Nullam cursus nec velit eget maximus.

Donec et interdum neque, quis efficitur ipsum. Vestibulum hendrerit a dolor ut bibendum. Vivamus tincidunt commodo erat sit amet condimentum. Sed at dolor et enim tristique dictum vel quis felis. Nam euismod mauris at dui laoreet tempus. Etiam sit amet lacinia felis. Sed vel sollicitudin sapien. Nullam est metus, faucibus vitae lacus in, elementum euismod ligula. Phasellus maximus tortor a iaculis dignissim. Morbi id finibus massa. Donec et lobortis quam, vel blandit diam. Ut quis accumsan urna.

Morbi tincidunt nibh vitae nibh sodales suscipit. Donec vitae lobortis quam, ac mollis tellus. Aliquam erat volutpat. Ut convallis maximus tellus, id interdum diam pretium tempus. Praesent ac mattis leo. Sed pretium est nec turpis fringilla varius a vel nunc. Morbi vehicula nulla arcu, non finibus nisl malesuada non. Nunc in hendrerit mauris. Proin nec cursus ligula, quis venenatis dolor. Integer nunc metus, vestibulum non aliquet eget, ultricies at lorem.

## Methodology

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel enim diam. Sed sollicitudin condimentum risus ut semper. Praesent pulvinar mauris quis aliquam tincidunt. Nullam vitae nulla sed lectus pharetra condimentum imperdiet ut mauris. Fusce sem neque, blandit a diam laoreet, auctor ornare odio. Donec viverra sapien nec mi tempus commodo. Vestibulum in tortor laoreet, porta ipsum sit amet, iaculis ligula. Sed hendrerit dui quis consectetur pharetra. Donec imperdiet consequat nisl, fringilla molestie arcu consectetur eget. Nullam cursus nec velit eget maximus. Cras convallis lorem urna, vel dictum purus ultrices aliquam. Curabitur scelerisque sit amet mauris non vulputate.

Donec et interdum neque, quis efficitur ipsum. Vestibulum hendrerit a dolor ut bibendum. Vivamus tincidunt commodo erat sit amet condimentum. Sed at dolor et enim tristique dictum vel quis felis. Nam euismod mauris at dui laoreet tempus. Etiam sit amet lacinia felis. Sed vel sollicitudin sapien. Nullam est metus, faucibus vitae lacus in, elementum euismod ligula. Phasellus maximus tortor a iaculis dignissim. Morbi id finibus massa. Donec et lobortis quam, vel blandit diam. Ut quis accumsan urna.

## Target LLM Models

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

Context:

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
 CONSTRAINT [PK_Activity_ActivityId] PRIMARY KEY CLUSTERED
(
    [ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
```

Given the table above, create the following stored procedures:

- **usp_[Entity]Insert** - include all columns as input parameters, except UpdatedDateTime, UpdatedByUser, UpdatedByProgram, and SystemTimestamp. It must explicitly have the columns CreatedDateTime, CreatedByUser, and CreatedByProgram as input parameters - these will come from the Web Application. Defaults all the nullable columns to NULL respecting the table definition.

- **usp_[Entity]Delete** - include only [Entity]Id, UpdatedDateTime, UpdatedByUser, UpdatedByProgram and SystemTimestamp as input parameters. The record must be soft-deleted (SystemDeleteFlag = 'Y'), the values for UpdatedDateTime, UpdatedByUser, UpdatedByProgram must be validated for null values, and should default, respectively, to SYSUTCDATETIME(), SYSTEM_USER and APP_NAME() if they are null. Finally, SystemTimestamp must be used to perform an optimistic lock verification.

- **usp_[Entity]Update** - include all the columns as input parameters, except CreatedDateTime, CreatedByUser, and CreatedByProgram. The values for UpdatedDateTime, UpdatedByUser, UpdatedByProgram must be validated for null values, and should default, respectively, to SYSUTCDATETIME(), SYSTEM_USER and APP_NAME() if they are null. The value from SystemTimestamp will be used to perform an optimistic lock verification.

- **usp_[Entity]Retrieve** - include all the columns from the table as input parameters, defaulting them to NULL, except UpdatedDateTime, UpdatedByUser, and UpdatedByProgram. The result-set must contain all the columns from the table definition. The input parameter ActiveFlag must default to 1 instead of NULL. The input parameter SystemDeletedFlag must be defaulted to 'N' instead of NULL. Both parameters ActiveFlag and SystemDeletedFlag do not require validation against NULL values in the body of the stored procedure. The columns UpdatedDateTime, UpdatedByUser, and UpdatedByProgram **SHOULD NOT** be used in this stored procedure.

- **usp_[Entity]RetrieveForList** - this stored procedure must retrieve all the non-deleted (SystemDeletedFlag <> 'Y') and active (ActiveFlag = 1) records of the type [Entity], and only two columns: [Entity]Id and Name. This list will be used to generate drop-down lists in the Web application layer.

For all the stored procedures:

1. Include '= NULL' after the input parameters that can be null based on the table definition; validate the input parameters for their types/sizes/nullability; raise an error 50001 for null parameters, an error 50002 for char, varchar, nchar and nvarchar parameters which extrapolate the length of the columns, and an error 50003 for invalid flag parameters (ActiveFlag must be either 0 or 1, and SystemDeletedFlag must be either 'N' or 'Y').

2. Include the statements SELECT, INSERT and UPDATE within a try...catch block; the catch block must include an insert to the table DbError as follows:

```sql
BEGIN CATCH
    -- Log the error in the table DbError
    INSERT INTO [dbo].[DbError] (
        ErrorNumber,
        ErrorSeverity,
        ErrorState,
        ErrorProcedure,
        ErrorLine,
        ErrorMessage
    )
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;
    RAISERROR('50000', 16, 1, 'Error occurred during [Operation] operation.');
END CATCH;
```

3. The stored procedure usp_[Entity]Retrieve must use the following pattern for varchar and nvarchar columns that are part of the search criteria:

```sql
(@Parameter IS NULL OR CHARINDEX(@Parameter, [Column], 0) > 0)
```

4. The stored procedure usp_[Entity]Retrieve also must use the following pattern for date, time, datetime or datetime2 columns included in the search criteria:

```sql
(@DateTimeParameter IS NULL OR DateTimeColumn >= @DateTimeParameter AND DateTimeColumn < DATEADD(day, 1, @DateTimeParameter))
```

5. For all the cases of optimistic lock violation: return an error 50004 with the message:

```txt
"Operation failed because another user has updated or deleted this [Entity]. Your changes have been lost. Please review their changes before trying again.".
```

6. Include each stored procedure in a separate SQL code block with all the necessary code for it to run.

Good luck.

## C# Model Generation

```txt
[placeholder]
```

## C# DTO Generation

```txt
[placeholder]
```

## C# ViewModel Generation

```txt
[placeholder]
```

## C# Repository Generation

```txt
[placeholder]
```

## Asp.Net Core Minimal API Generation

```txt
[placeholder]
```

## Asp.Net Core Razor Pages Generation

```txt
[placeholder]
```

## Unit Tests Generation (with NUnit)

```txt
[placeholder]
```

## Integrated Tests Generation (With Moq)

```txt
[placeholder]
```

## Results

```txt
[placeholder]
```

### T-SQL Generation

```txt
[placeholder]
```

### C# Models

```txt
[placeholder]
```

### C# DTOs

```txt
[placeholder]
```

### C# ViewModels

```txt
[placeholder]
```

### C# Repositories

```txt
[placeholder]
```

### Asp.Net Core Minimal APIs

```txt
[placeholder]
```

### Asp.Net Core Razor Page(s)

```txt
[placeholder]
```

### Unit Tests results

```txt
[placeholder]
```

### Integration Tests results

```txt
[placeholder]
```

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

Found these findings useful? Leave a star. :-)
