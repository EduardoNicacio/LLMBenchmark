CREATE PROCEDURE usp_ActivityInsert
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
    @ActiveFlag TINYINT,
    @SystemDeleteFlag CHAR(1),
    @CreatedDateTime DATETIME2(7),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF (@ActivityId IS NULL)
        RAISERROR('Error 50001: ActivityId cannot be null.', 16, 1);
    IF (@ProjectId IS NULL)
        RAISERROR('Error 50001: ProjectId cannot be null.', 16, 1);
    IF (@ProjectMemberId IS NULL)
        RAISERROR('Error 50001: ProjectMemberId cannot be null.', 16, 1);
    IF (@Name IS NULL OR LEN(@Name) > 128)
        RAISERROR('Error 50002: Name exceeds maximum length of 128 characters.', 16, 1);
    IF (@Description IS NULL OR LEN(@Description) > 4000)
        RAISERROR('Error 50002: Description exceeds maximum length of 4000 characters.', 16, 1);
    IF (@ActiveFlag NOT IN (0, 1))
        RAISERROR('Error 50003: ActiveFlag must be 0 or 1.', 16, 1);
    IF (@SystemDeleteFlag NOT IN ('N', 'Y'))
        RAISERROR('Error 50003: SystemDeleteFlag must be ''N'' or ''Y''.', 16, 1);
    IF (@CreatedDateTime IS NULL)
        RAISERROR('Error 50001: CreatedDateTime cannot be null.', 16, 1);
    IF (@CreatedByUser IS NULL OR LEN(@CreatedByUser) > 100)
        RAISERROR('Error 50002: CreatedByUser exceeds maximum length of 100 characters.', 16, 1);
    IF (@CreatedByProgram IS NULL OR LEN(@CreatedByProgram) > 100)
        RAISERROR('Error 50002: CreatedByProgram exceeds maximum length of 100 characters.', 16, 1);

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
            [CreatedByProgram],
            [SystemTimestamp]
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
            @CreatedByProgram,
            DEFAULT
        );

        -- Success
        SELECT 1 AS Result;
    END TRY
    BEGIN CATCH
        -- Log error
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorTime)
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            GETUTCDATE()
        );

        -- Raise error
        RAISERROR('Error 50000: Error occurred during ActivityInsert operation.', 16, 1);
    END CATCH
END;
GO
