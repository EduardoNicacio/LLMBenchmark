-- usp_ActivityInsert
CREATE PROCEDURE usp_ActivityInsert
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE,
    @TargetDate DATE,
    @EndDate DATE,
    @ProgressStatus TINYINT,
    @ActivityPoints SMALLINT,
    @Priority TINYINT,
    @Risk TINYINT,
    @Tags NVARCHAR(200),
    @ActiveFlag TINYINT,
    @SystemDeleteFlag CHAR(1),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
    BEGIN
        RAISERROR('50001', 16, 1, 'Null parameter detected in usp_ActivityInsert');
        RETURN;
    END

    IF @Name IS NOT NULL AND LEN(@Name) > 128
    BEGIN
        RAISERROR('50002', 16, 1, 'Name exceeds maximum length of 128 characters');
        RETURN;
    END

    IF @Description IS NOT NULL AND LEN(@Description) > 4000
    BEGIN
        RAISERROR('50002', 16, 1, 'Description exceeds maximum length of 4000 characters');
        RETURN;
    END

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
    BEGIN
        RAISERROR('50002', 16, 1, 'Tags exceeds maximum length of 200 characters');
        RETURN;
    END

    IF @ActiveFlag NOT IN (0, 1)
    BEGIN
        RAISERROR('50003', 16, 1, 'Invalid ActiveFlag value. Must be 0 or 1.');
        RETURN;
    END

    IF @SystemDeleteFlag NOT IN ('N', 'Y')
    BEGIN
        RAISERROR('50003', 16, 1, 'Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.');
        RETURN;
    END

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
            SYSUTCDATETIME(),
            @CreatedByUser,
            @CreatedByProgram
        );

        RETURN 0;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorMessage, Operation, ErrorNumber, ErrorSeverity, ErrorState, ErrorLine, ErrorProcedure)
        VALUES (ERROR_MESSAGE(), 'INSERT', ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

        RAISERROR('50000', 16, 1, 'Error occurred during INSERT operation.');
        RETURN -1;
    END CATCH
END
GO
