# Model

- [lmstudio-community/codegemma-7b-GGUF](https://model.lmstudio.ai/download/lmstudio-community/codegemma-7b-GGUF)

## Summary

**CodeGemma** is a collection of lightweight open code models built on top of Gemma. CodeGemma models are text-to-text and text-to-code decoder-only models and are available as a 7 billion pretrained variant that specializes in code completion and code generation tasks, a 7 billion parameter instruction-tuned variant for code chat and instruction following and a 2 billion parameter pretrained variant for fast code completion.

## Sample Usage

This model is intended to answer questions about code fragments, to generate code from natural language, or to engage in a conversation with the user about programming or technical problems. If you need to use code completion (for example, integrated in an IDE), we recommend you use one of the pre-trained models instead: [CodeGemma 7B](https://huggingface.co/google/codegemma-7b), or [CodeGemma 2B](https://huggingface.co/google/codegemma-2b).

## LLM Studio Parameters

- Context length: 4096
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

- Thought for: 0min0.1s
- Tokens per second: ~ 81.40

## Observations

Failed in all code tasks (examples below).
I'm still figuring out what went wrong as this model has been higly praised, online, for its code generation/code completion capabilities.

```sql
CREATE PROCEDURE [dbo].[Activity Insert](@ProjectId uniqueidentifier = NULL, @ProjectMemberId UNIQUEIDENTIFIER=NULL ,Name nvarchar(128)=null) -- add more parameters as needed 

AS BEGIN TRANSACTION; SET NOCOUNT ON ;
-- Declare and Validate Input Parameters Start --------------------- START --------------   

IF LEN(@EntityID ) > (SELECT TOP  FROM dbo.Activity WHERE ActivityId = @activityid AND SystemDeleteFlag ='N') RAISERROR ('5064',18,2) -- Error 

END IF ;
-- Declare and Validate Input Parameters End --------------------- END --------------   

BEGIN TRY

INSERT INTO [dbo].[Entity] (  [ProjectId],    ProjectMemberId , Name ) VALUES( @projectid = NULL ? 'NULL' : '',@projectmemberid= null? '' :'',name) -- add more parameters as needed 
-- INSERT Statement End --------------------- END --------------   

END TRY BEGIN CATCH RAISERROR('5046132897','Activity Insert Operation Failed: ',Error_Message());  --- Error Message for optimistic lock violation ---    

COMMIT TRANSACTION; SET NOCOUNT OFF ; -- COMMIT Transaction and Disable NoCount ON 
-- End of Stored Procedure --------------------- END --------------   
```

```sql
-- usp_[Entity]Delete -- BEGIN TRY DECLARE @SystemTimestamp datetime = SYSUTCDATETIME(); UPDATE [dbo].[Activity]( ActivityId, ActiveFlag) SET SystemDeletedDateTime = NULL IF(ISNULL(@systemtimestampParam),@SYSTEMTIMESTAMPPARAMSATE);   COMMIT TRANSACTION  END CATCH    IF @@TRANCOUNT > 3 GOTO FINISH WITH ROLLBACK IMMEDIATE; COMMIT TRANFINISH GO
```

```sql
-- usp_[Entity]Update BEGIN TRY DECLARE @SystemTimestamp datetime = SYSUTCDATETIME(); UPDATE [dbo].[Activity]( ActivityId, ActiveFlag) SET SystemDeletedDateTime = NULL IF(ISNULL(@systemtimestampParam),@SYSTEMTIMESTAMPPARAMSATE);   COMMIT TRANSACTION  END CATCH    IF @@TRANCOUNT > 3 GOTO FINISH WITH ROLLBACK IMMEDIATE; COMMIT TRANFINISH GO
```

```sql
-- usp_[Entity]Retrieve BEGIN TRY DECLARE @SystemTimestamp datetime = SYSUTCDATETIME(); UPDATE [dbo].[Activity]( ActivityId, ActiveFlag) SET SystemDeletedDateTime = NULL IF(ISNULL(@systemtimestampParam),@SYSTEMTIMESTAMPPARAMSATE);   COMMIT TRANSACTION  END CATCH    IF @@TRANCOUNT > 3 GOTO FINISH WITH ROLLBACK IMMEDIATE; COMMIT TRANFINISH GO
```

```sql
-- usp_[Entity]RetrieveForList BEGIN TRY DECLARE @SystemTimestamp datetime = SYSUTCDATETIME(); UPDATE [dbo].[Activity]( ActivityId, ActiveFlag) SET SystemDeletedDateTime = NULL IF(ISNULL(@systemtimestampParam),@SYSTEMTIMESTAMPPARAMSATE);   COMMIT TRANSACTION  END CATCH    IF @@TRANCOUNT > 3 GOTO FINISH WITH ROLLBACK IMMEDIATE; COMMIT TRANFINISH GO
```

I then decided to try again with the 'non instruct' model, with the same results: it also failed all the coding tasks (see example below):

```sql
CREATE PROCEDURE usp_ActivityInsert(  @ProjectId uniqueidentifier, 
    -- ProjectId - NOT NULL column; datatype = UNIQUEIDENTIFIER from table [ProjectMember] of type PROJECTMEMBERENTITY (Relationship constraint: FOREIGN KEY) FK__Activitie __Proje... referencing dbo.PROJECT member [dbo].[FK15A4DE92CC7B608D].
    @Name nvarchar(MAX), 

    -- Name - NOT NULL column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @Description nvarchar(MAX), 

    -- Description - NOT NULL column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @StartDate date=NULL , 

    -- StartDate - NULLABLE column; datatype = DATE from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @TargetEndDate date=NULL , 

    -- TargetDate - NULLABLE column; datatype = DATE from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @EndDate date=NULL , 

    -- EndDate - NULLABLE column; datatype = DATE from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @ProgressStatus tinyint=NULL , 

    -- Progress - NULLABLE column; datatype = TINYINT from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @Priority tinyint=NULL , 

    -- Priority - NULLABLE column; datatype = TINYINT from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @Risk tinyint=NULL , 

    -- Risk - NULLABLE column; datatype = TINYINT from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @Tags nvarchar(MAX)=NULL , 

    -- Tags - NULLABLE column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @ActiveFlag tinyint=1 , 

    -- Active - NOT NULL column; datatype = TINYINT from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @SystemDeleteFlag CHAR(1)=N'0', 

    -- SystemDeleted - NOT NULL column; datatype = BIT from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @CreatedDateTime datetime2(7), 

    -- Created - NOT NULL column; datatype = DATETIME from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @CreatedByUser nvarchar(10), 

    -- CreatedByUser - NOT NULL column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @CreatedByProgram nvarchar(10), 

    -- CreatedByApplication - NOT NULL column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column not nullable, so must be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @UpdatedDateTime datetime2(7), 

    -- Updated - NULLABLE column; datatype = DATETIME from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @UpdatedByUser nvarchar(10), 

    -- UpdatedByApplication - NULLABLE column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @UpdatedByProgram nvarchar(10), 

    -- UpdatedByApplication - NULLABLE column; datatype = NVARCHAR from table Activity of type ACTIVITYENTITY . (Relationship constraint: NO FOREIGN KEY) No FK for this relationship. Column nullable, so can be included in the INSERT statement when executing stored procedure usp_ActivityInsert using parameters
    @SystemTimestamp timestamp(7))

AS

BEGIN TRY -- Try...Catch block to handle errors during insert operation - begin transaction and commit if successful or roll back on failure  - all code within BEGIN..END must have a single level of nesting for it's error handling. So, you cannot use nested try/catch blocks; instead just add an additional catch statement immediately following the first one:
    BEGIN TRANSACTION 

    -- Set variables to NULL if null values are passed in through parameters - validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    DECLARE @ProjectIdVar uniqueidentifier = COALESCE(@ProjectMemberId, NULL), 

    -- ProjectId - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @NameVar nvarchar(138)=COALESCE(@ProjectMemberId, NULL), 

    -- Name - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @DescriptionVar nvarchar(438)=COALESCE(@ProjectMemberId, NULL), 

    -- Description - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @StartDateVar date = COALESCE(@ProjectMemberId, NULL), 

    -- StartDate - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @TargetEndDateVar date = COALESCE(@ProjectMemberId, NULL), 

    -- TargetDate - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @EndDateVar date = COALESCE(@ProjectMemberId, NULL), 

    -- EndDate - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @ProgressStatusVar date = COALESCE(@ProjectMemberId, NULL), 

    -- Progress - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @PriorityVar date = COALESCE(@ProjectMemberId, NULL), 

    -- Priority - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @RiskVar date = COALESCE(@ProjectMemberId, NULL), 

    -- Risk - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @TagsVar date = COALESCE(@ProjectMemberId, NULL), 

    -- Tags - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @ActiveFlagVar date = COALESCE(@ProjectMemberId, NULL), 

    -- Active - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @SystemDeleteFlagVar date = COALESCE(@ProjectMemberId, NULL), 

    -- SystemDeleted - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @CreatedDateTimeVar datetime = COALESCE(@ProjectMemberId, NULL), 

    -- Created - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @CreatedByUserVar datetime = COALESCE(@ProjectMemberId, NULL), 

    -- CreatedByUser - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @CreatedByProgramVar datetime = COALESCE(@ProjectMemberId, NULL), 

    -- CreatedByApplication - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @UpdatedDateTimeVar datetime = COALESCE(@ProjectMemberId, NULL), 

    -- Updated - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @UpdatedByUserVar datetime = COALESCE(@ProjectMemberId, NULL), 

    -- UpdatedByApplication - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @UpdatedByProgramVar datetime = COALESCE(@ProjectMemberId, NULL), 

    -- UpdatedByApplication - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
    @SystemTimestampVar datetime = COALESCE(@ProjectMemberId, NULL); 

    -- SystemTimeStamp - NOT NUll column with default null for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.

    IF @ProjectIdVar ISNULL
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'ProjectMember Id must not null.');

    IF LEN(@NameVar)>138 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Name length must not exceed or must null.');

    IF LEN(@DescriptionVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Description length must not exceed or null.');

    IF LEN(@StartDateVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Start date must not exceed or null.');

    IF LEN(@TargetEndDateVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Target End Date must not exceed or null.');

    IF LEN(@EndDateVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'End Date must not exceed or null.');

    IF LEN(@ProgressStatusVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Progress Status must not exceed or null.');

    IF LEN(@PriorityVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Priority must not exceed or null.');

    IF LEN(@RiskVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Risk must not exceed or null.');

    IF LEN(@TagsVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Tags must not exceed or null.');

    IF LEN(@ActiveFlagVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Active Flag must not exceed or null.');

    IF LEN(@SystemDeleteFlagVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'System Delete Flag must not exceed or null.');

    IF LEN(@CreatedDateTimeVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Created Date Time must not exceed or null.');

    IF LEN(@CreatedByUserVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Created By User must not exceed or null.');

    IF LEN(@CreatedByProgramVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Created By Program must not exceed or null.');

    IF LEN(@UpdatedDateTimeVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Updated Date Time must not exceed or null.');

    IF LEN(@updatedByUserVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Updated By User must not exceed or null.');

    IF LEN(@UpdatedByProgramVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'Updated By Program must not exceed or null.');

    IF LEN(@SystemTimestampVar)>438 OR @ProjectId ISNULL -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        RAISERROR(41387, 9 , - -- validate each input parameter against their respective column data types and nullability for table [Activity]  - datatype validation: tinyint is a small integer value (0..256) so it cannot be used as an error code; use int instead.
        'System Timestamp must not exceed or null.');

-- usp_EntityInsert - include all columns in the input parameters, except UpdatedDateTime and SystemTimestamp 

CREATE PROCEDURE [dbo].[usp_{{entity}}Retrieve]  (    @{{property}}.Name nvarchar (128) = NULL @ {{ property }}.Descriptionnvarchar.4096=NULL,@StartDate date-Null
--date: datetime=@TargetDate Date - Null, EndDAte Date - null ProgressStatus smallint default 3 ActivityPoints smallInt Default 5 Priority tinyINT DeFAULT --risk TINYITN DEFAUlT Tags nVARCHAR(2O) = NULLActiveFlagTiny int=1 SystemDeleteFlagchar1 ='y' CreatedDateTime DATETIME DEFAULT SYSUTCDATETiME CREATEDBYUSER NVarchar(lOO)=SYSTEM_U
--ser,CREATEDbyPROGRAM NVARChAr('A PPNA ME'),UPDATEDDATETIME Date TIMe(7) NULL UPDATEDByusernvarchar (lO0),UpdatedbYprOgramNVARCHAR()

@{{property}}.Id uniqueidentifier = 3AA1E2F5-F48D - A9B6–4C60 – B8CC – EBD5AEEFBFCD,@SystemTimestamp timestamp=NULL) AS BEGIN SET NOCOUNT ON; DECLARE @ErrorMessage NVARCHAR(MAX),@ErrorSeverity INT,
--errorState TINYINT

SET XACT_ABORTON SELECT * FROM [dbo].[Activity] WHERE({{property}}.Id = (IS NULL OR {{ property }}.ID=@{{ Property }} . ID)AND Name =( IS Null or CHARINDEX(@Name,@NamE , 0)) AND Description=(isnullORCHARindex@DesCription, @Description.,O), StartDate= isnull(Convertdateformat({{property}}.StartDate ),
--targetDAte datetime =isNULLconvertDATEFORMAT('{{ property }}.Target Date',0) EndDatETiMe DATETIME IS NULL OR CONVERT.DATETIME {{ Property }} .EndDate  ORCHARINDEX(@EndDATe, {PROPERTY}} END DATE ,O)) ProgressStatus =(isnullorcharindex@progressstatus,@ProgressStatuS 3), ActivityPoints = (ISNULL or charindeX @Acticvitypoints
--activity points)priority TINYINT= IS NULL OR CHARINDEC(PRIORITY=@ priorityTinyint Risk TinyInt Default Is Null Or CharIndex (@Risk, RISK tiny int ,0)) Tags NVARCHAR2O)= isnullorcharindex@TagS,@Tags 8), ActiveFlag =(isnullOrCHARINDEX @activeflag = active flag TINYINT=1 SystemDeleteFlag char(I) ='y' CreatedDateTime DATETiME DEFAULT SYSUTCDATeTime, CREATEDBYUSER NVarchar (lO0)=SYSTEM_User
-- ,CREATEDbyPROGRAMNVARChAr('appname'),UPDATEDDATETIME datetime =(isnullorcharindex@updateddatetimE,@ updateddatetime 7), UPDATEDByusernvarchar(lOO) = SYSTEM _ userUpdatedbYprOgram NVARCHAR() SystemTimestamp timestamp=NULL

IF @@TRANCOUNT >0 ROLLBACK TRAN; RAISERROR(@ErrorMessage, @ErrorSeverity ,1); END CATCH SELECT * FROM[dbo].[Activity] WHERE({{property}}.Id =( IS NULL OR {{ property }}.ID=@{{ Property }} . ID)AND Name = ( I$Null or CHARINDEX@Name,@NamE 0)) AND Description=(isnullORCHARindex(@DesCription, @Description.,O), StartDate= isnull(Convertdateformat({{property}}.StartDate ),
--targetDAte datetime =(isNULLorcharindeX{{ Property }} .Target Date ,o) EndDatETiMe DATETIME = IS NULL OR CONVERT.DATETIME {{ property }}.EndDate ,0)) ProgressStatus=(isnullOrCHARindex@progressstatus, @ProgressStatuS TINYint 3), ActivityPoints= (ISNullORchArindeX{{ Property }} .activity points
--)priority TinyINT =(iSnULLorcharIndex Priority=@ priorityTinyInt Risk tiny Int Default is nUll or charIndex(@Risk,@ RISK tinYt int,O)) Tags NVARCHAR20)=isNulLorChAriNdEX@TagS @Tags 8), ActiveFlag=(isnullOrCHARindex {{ Property }} .active flag TINYINT =1 SystemDeleteFlag chAr(I) ='y' CreatedDateTime DATETiME DEFAULT SYSUTCDATeTime, CREATEDBYUSER NVarchar (lO0)=SYSTEM_User
-- ,CREATEDbyPROGRAMNVARChAr('appname'),UPDATEDDATETIME datetime =(isnullORchAriNdEx@updateddatetimE @ updateddatetime7), UPDATEDByusernvarchar(lOO) = SYSTEM _ userUpdatedbYprOgram NVARCHAR() SystemTimestamp timestamp=NULL

END
```

If I was paid by line of code to produce garbage, this would be my model of choice. :-)
