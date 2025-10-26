# Benchmark summary

## servicenow-ai/apriel-1.5-15b-thinker:

- Differently from other "thinking" or "reasoning" models, it displays its chain of thought directly in the LM Studio chat output.
- It included a nice documentation at the header of each stored procedure, and split them all into separate code blocks as asked.
- It missed some explicit instructions, like not using Update* as input parameters in the retrieve stored procedures.
- On the other hand, it was one of the few models to suggest a cleaner way of handling parameter validation and execution error logging by using a separate stored procedure, called `dbo.RunWithErrorLogging`.
- This model took longer to complete these tasks because it generated two sets of stored procedures, with and without the try...catch block for handling errors on Insert, Update or Select operations.
- The model generated tons of C# code. However, when outputting the latest classes after a long thought, it ran out of context/memory and could not proceed. A 24/32GB video card may help with that.
- The model spent over 2h of GPU time writing C# code and fine-tunning it. I've aborted the execution on the final step, when the model was about to display its final answer. On a second attempt I let the model run loose and, after 4 hours of thinking/planning, it crashed.

## google/codegemma-7b:

- Strange results, like the model not generating anything at 153,846 tokens per second; or hallucinating by affirming that using python with an ORM would be better than running the requested stored procedures.
- Other times, the model generates garbage like below until it crashes:

    ```sql
    -- usp_ActivityInsert 501f84e3-736d - d9a2bcbecfbdbfaeabebbdcfdcabdcfe -- Description: Insert new Activity record. Input parameters include all columns except UpdatedDateTime, Updat eedByUser ,UpdatedByProgram and SystemTimestamp . Explicitly specify CreatedDateTim
    -- usp_ActivityDelete 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Delete existing Activity record. Input parameters include all columns except UpdatedDateTime, Updat eedByUser ,UpdatedByProgram and SystemTimestamp . Soft delete by setting Syst
    -- usp_ActivityUpdate 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Update existing Activity record. Input parameters include all columns except CreatedDateTime, Cr eatedByUser ,CreatedByProgram .
    -- usp_ActivityRetrieve 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Retrieve existing Activity record. Input parameters include all columns except Updat edDateTim e, UpdatedByUser ,UpdatedByProgram .
    -- usp_ActivityRetrieveForList 501f84e3-726d - d9aebcbecfbdbfaeabebbdcfdcabdcfe -- Description: Retrieve Activity record for list. Input parameters include all columns except Updat edDateTim e, UpdatedByUser ,UpdatedByProgram .
    ```

## mistralai/codestral-22b-v0.1:

- Didn't validate the input parameters as instructed.
- Didn't include the main statements within a try...catch block as instructed.
- Assumed a Python environment by default:

    > This is Python environment, but it seems like you're asking to write SQL code. Here's an example of how your procedures could be written:

- In C# code generation tasks, it only provided skeletons for a few classes and nothing else. According to the model, creating Asp.Net Razor pages, unitary and integration `won't be provided here due to the complexity of the task`.

## cohere/command-a-03-2025

- Didn't include input parameter validation for all the stored procedures. On the other hand, included optimistic lock error handling.
- Included the following notes:
  - Replace [dbo].[DbError] with your actual error logging table if different.
  - Ensure the TIMESTAMP column is handled correctly for optimistic locking in your environment.
  - Test each stored procedure thoroughly before deploying to production.

## deepseek/deepseek-coder-v2-lite-instruct

- Didn't include any parameter validation (error codes 50001, 50002, 50003) as required.
- Used error code 50003 within the try...catch block, which should be used to validate the flag parameters (ActiveFlag, SystemDeleteFlag).
- Didn't follow the instructions to generate production-ready C# code. Here's the message this model provided at the end of the task:

    ```txt
    This setup provides a comprehensive example of how to structure a full-stack .NET application based on the provided SQL table definition, following best practices and including necessary validation and testing. Adjust namespaces and paths according to your project's actual structure.
    ```

## mistralai/devstral-small-2507

- Didn't break each stored procedure into a separate code block for easy copy and paste. Resolved with the extra command below:

    ```txt
    Split each stored procedure above into its corresponding SQL code block.
    ```

- Included an extra utility function to validate input parameters, and an extra stored procedure to store the execution errors. Nice. :-)
- Didn't generate a complete, production-ready C# code. Ended up with the message below:

    ```txt
    This completes the full-stack .NET application components for the Activity table. Each component is designed following best practices and includes proper validation and testing mechanisms.
    ```

## google/gemma-3-12b

- Didn't create each stored procedure on its own SQL code block as instructed.
- Didn't create all the necessary code for a full-stack .Net solution; partially resolved with the extra command below:

    ```txt
    Create the remaining parts - EF Core Repository, Minimal API, Razor Pages, Unit Tests, and Integration Tests - for a full-stack .Net solution.
    ```

- Didn't generate the Razor pages and page models as instructed; resolved with the following extra command:

    ```txt
    Create the required Razor Pages (Create, Edit, Details, Delete, Index) as you have been instructed.
    ```

- Provided some important notes at the end of the ask as follows:

    ```txt
    Important Notes:

    - DbContext Configuration: You must configure your MyApplicationDbContext to connect to your database.
    - Dependency Injection: Register the repository and API controller with your dependency injection container (e.g., in Program.cs).
    - Error Handling & Validation: Implement comprehensive error handling and validation throughout all components.
    - Security: Add authentication and authorization middleware for production use.
    - Data Transfer Objects (DTOs): Use DTOs to decouple your API from your model. This allows you to change the underlying data structure without affecting the exposed API contract.
    - Pagination & Sorting: Implement pagination and sorting on the list view to handle large datasets efficiently.
    - Testing: Write comprehensive unit tests and integration tests to ensure code quality and reliability.
    
    This comprehensive response provides a solid foundation for your full-stack .NET application. Remember to adapt it to your specific project requirements and best practices.  Let me know if you'd like more details on any particular component!
    ```

- After creating the missing Razor pages, provided the following important considerations:

    ```txt
    Important Considerations:

    - Routing: Ensure your _Layout.cshtml and Pages/_Layout.cshtml are configured correctly for routing to these pages.
    - Data Binding & Validation: Adjust the data binding attributes (asp-for, asp-validation-for) as needed for your specific model properties.
    - Error Handling: Add error handling (try-catch blocks) and display appropriate error messages to users.
    - UI Framework: These pages use basic HTML. You can enhance them with a CSS framework like Bootstrap or Tailwind CSS.

    This provides the core Razor Pages functionality.  Remember that this is a starting point, and you'll need to customize it further based on your application’s specific needs.
    ```

## openai/gpt-oss-20b

- Stopped mid-execution due to context max size of 4096. Needed to be restarted with a larger context of 8192 tokens.
- Very good performance on both tasks. Added sweet comments throughout the code.
- Correctly used square bracket around column names that can be mistaken by MS SQL server reserved words, like Name and Description.
- Suggested all the Nuget packages required by the full-stack .Net code:

    ```txt
    ⚠️ The code assumes you have the following NuGet packages installed:

    Microsoft.EntityFrameworkCore (and EF‑Core provider of your choice)
    Microsoft.AspNetCore.Mvc.RazorPages
    Microsoft.Extensions.DependencyInjection
    Microsoft.AspNetCore.Http.Json
    NUnit, Moq, Microsoft.NET.Test.Sdk, coverlet.collector (for the tests)
    ```

- Provided the right folder structure in which I should drop the files:

    ```txt
    MyApp/
    ├─ Models/
    │   └─ Activity.cs
    ├─ DTOs/
    │   ├─ ActivityCreateDto.cs
    │   ├─ ActivityUpdateDto.cs
    │   └─ ActivityReadDto.cs
    ├─ ViewModels/
    │   ├─ ActivityCreateViewModel.cs
    │   ├─ ActivityUpdateViewModel.cs
    │   └─ ActivityListViewModel.cs
    ├─ Data/
    │   ├─ AppDbContext.cs          // EF Core DbContext
    │   ├─ IRepository.cs
    │   ├─ GenericRepository.cs
    │   ├─ IActivityRepository.cs
    │   └─ ActivityRepository.cs
    ├─ Pages/
    │   └─ Activities/
    │       ├─ Index.cshtml / Index.cshtml.cs
    │       ├─ Create.cshtml / Create.cshtml.cs
    │       ├─ Edit.cshtml / Edit.cshtml.cs
    │       ├─ Details.cshtml / Details.cshtml.cs
    │       └─ Delete.cshtml / Delete.cshtml.cs
    ├─ Program.cs                     // Minimal API + DI config
    └─ Tests/
        ├─ Unit/
        │   ├─ ModelValidationTests.cs
        │   ├─ DtoMappingTests.cs
        │   └─ ViewModelPropertyTests.cs
        └─ Integration/
            ├─ RepositoryIntegrationTests.cs
            ├─ MinimalApiIntegrationTests.cs
            └─ RazorPagesIntegrationTests.cs
    ```

## ibm/granite-4-h-tiny

- Didn't create each stored procedure on its own code block as instructed.
- Simplistic, broken stored procedures - cannot be compiled.
- Repeated the SQL prompt with a refined version and it performed very well!
- Even though it didn't create all the required C# code, at least it provided a justification:

    ```txt
    Given the complexity of this task, I'll provide an overview and key components for each part rather than full files due to length constraints. Each section will include comments explaining its purpose.
    ```

- Model didn't provide a folder structure for the C# code, that's why every artifact can be found at the same level/folder.

## meta-llama/llama-3.1-8b-Instruct

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

## microsoft/phi-4-reasoning-plus

- Didn't observe the instruction to break the generated stored procedures into separate code blocks.
- The C# code generation was messy; not only it didn't break each file into a separate code block, but also transformed parts of the code into markdown headers.
- Even though this isn't a coding-specific model, for being a Microsoft release I was expecting better results on both coding tasks.

## qwen/qwen2.5-coder-14b

- Same output quality of qwen3-4b-2507, but almost three times slower.
- Didn't create each stored procedure into a single code block as requested.
- I needed to manually request the code generation for some missing pages (`Edit`, `Details`, `Delete`, and `Index`), as well as the missing repository methods `GetByIdAsync()`, `AddAsync()`, `Update()` and `Delete()` as defined in the interface IGenericRepository. Not all the methods defined in this interface have been implemented in the (`IQueryable<T> GetAll()` vs `Task<List<ReadActivityDto>> GetAllAsync()`).

## qwen/qwen3-4b-2507

- Good performance.
- Along with [qwen3-4b-thinking-2507](/qwen3-4b-thinking-2507/readme.md), this was the only model to include all the columns with squared brackets, a good practice in MS SQL server.
- Good quality in general; included appropriate comments for code documentation across the board; only model to generate the Razor pages with Bootstrap tags for the form elements.
- Model appeared to have forgotten to generate the code-behind classes for all the Razor pages.

## qwen/qwen3-4b-thinking-2507

- Good performance. Most comprehensive source code.
- Along with [qwen3-4b-2507](/qwen3-4b-2507/readme.md), this was the only model to include all the columns with squared brackets, a good practice in MS SQL server.
- Model didn't create all the required C# code, but gave me some tips as follows:

    ```txt
    File: Pages/Activities/Edit.cshtml (Structure similar to Create, with @model UpdateActivityViewModel)
    File: Pages/Activities/Details.cshtml (Structure: @model ReadActivityDto)
    File: Pages/Activities/Delete.cshtml (Structure: Confirmation form with @model Guid)

    Note: Razor Pages use Model Binding and ASP.NET Core validation. All pages include proper error handling and form submission.
    ```