-- usp_ActivityInsert
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
    @ActiveFlag TINYINT = NULL,
    @SystemDeleteFlag CHAR(1) = NULL,
    @CreatedDateTime DATETIME2(7),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF @ActivityId IS NULL
        RAISERROR('50001', 16, 1, 'ActivityId') RETURN;

    IF @ProjectId IS NULL
        RAISERROR('50001', 16, 1, 'ProjectId') RETURN;

    IF @ProjectMemberId IS NULL
        RAISERROR('50001', 16, 1, 'ProjectMemberId') RETURN;

    IF @Name IS NULL OR LEN(@Name) > 128
        RAISERROR('50002', 16, 1, 'Name', 128) RETURN;

    IF @Description IS NULL OR LEN(@Description) > 4000
        RAISERROR('50002', 16, 1, 'Description', 4000) RETURN;

    IF @StartDate IS NOT NULL AND @StartDate > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'StartDate', 9999) RETURN;

    IF @TargetDate IS NOT NULL AND @TargetDate > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'TargetDate', 9999) RETURN;

    IF @EndDate IS NOT NULL AND @EndDate > CAST('9999-12-31' AS DATE)
        RAISERROR('50002', 16, 1, 'EndDate', 9999) RETURN;

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
        RAISERROR('50002', 16, 1, 'Tags', 200) RETURN;

    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag != 0 AND @ActiveFlag != 1)
        RAISERROR('50003', 16, 1, 'ActiveFlag') RETURN;

    IF @SystemDeleteFlag IS NOT NULL AND (@SystemDeleteFlag != 'N' AND @SystemDeleteFlag != 'Y')
        RAISERROR('50003', 16, 1, 'SystemDeleteFlag') RETURN;

    IF @CreatedDateTime IS NULL
        RAISERROR('50001', 16, 1, 'CreatedDateTime') RETURN;

    IF @CreatedByUser IS NULL OR LEN(@CreatedByUser) > 100
        RAISERROR('50002', 16, 1, 'CreatedByUser', 100) RETURN;

    IF @CreatedByProgram IS NULL OR LEN(@CreatedByProgram) > 100
        RAISERROR('50002', 16, 1, 'CreatedByProgram', 100) RETURN;

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
            ISNULL(@ActiveFlag, 1),
            ISNULL(@SystemDeleteFlag, 'N'),
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
        RETURN;
    END CATCH
END
GO
