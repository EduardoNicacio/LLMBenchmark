-- usp_ActivityInsert
CREATE OR ALTER PROCEDURE usp_ActivityInsert
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1,
    @SystemDeleteFlag CHAR(1) = 'N',
    @CreatedDateTime DATETIME2(7),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
BEGIN
    DECLARE @ErrorCode INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000);

    -- Validate parameters for nullability and types
    IF @ActivityId IS NULL
        RAISERROR('50001', 16, 1, 'ActivityId cannot be null');
    IF @ProjectId IS NULL
        RAISERROR('50001', 16, 1, 'ProjectId cannot be null');
    IF @ProjectMemberId IS NULL
        RAISERROR('50001', 16, 1, 'ProjectMemberId cannot be null');
    IF @Name IS NULL
        RAISERROR('50001', 16, 1, 'Name cannot be null');
    IF @Description IS NULL
        RAISERROR('50001', 16, 1, 'Description cannot be null');
    IF @CreatedDateTime IS NULL
        RAISERROR('50001', 16, 1, 'CreatedDateTime cannot be null');
    IF @CreatedByUser IS NULL
        RAISERROR('50001', 16, 1, 'CreatedByUser cannot be null');
    IF @CreatedByProgram IS NULL
        RAISERROR('50001', 16, 1, 'CreatedByProgram cannot be null');

    IF @ActiveFlag NOT IN (0, 1)
        RAISERROR('50003', 16, 1, 'ActiveFlag must be 0 or 1');
    IF @SystemDeleteFlag NOT IN ('Y', 'N')
        RAISERROR('50003', 16, 1, 'SystemDeleteFlag must be ''Y'' or ''N''');

    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
            [ActivityId],
            [ProjectId],
            [ProjectMemberId],
            [Name],
            [Description],
            [StartDate],
            [TargetDate],
            [EndDate],
            [ProgressStatus],
            [ActivityPoints],
            [Priority],
            [Risk],
            [Tags],
            [ActiveFlag],
            [SystemDeleteFlag],
            [CreatedDateTime],
            [CreatedByUser],
            [CreatedByProgram]
        )
        VALUES (
            @ActivityId,
            @ProjectId,
            @ProjectMemberId,
            @Name,
            @Description,
            @StartDate,
            @TargetDate,
            @EndDate,
            @ProgressStatus,
            @ActivityPoints,
            @Priority,
            @Risk,
            @Tags,
            @ActiveFlag,
            @SystemDeleteFlag,
            @CreatedDateTime,
            @CreatedByUser,
            @CreatedByProgram
        );
    END TRY
    BEGIN CATCH
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
        RAISERROR('50000', 16, 1, 'Error occurred during insertion');
    END CATCH
END
GO
