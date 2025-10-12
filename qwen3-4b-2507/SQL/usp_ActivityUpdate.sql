-- usp_ActivityUpdate
CREATE PROCEDURE usp_ActivityUpdate
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
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
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

    IF @UpdatedDateTime IS NULL
        SET @UpdatedDateTime = SYSUTCDATETIME();

    IF @UpdatedByUser IS NULL
        SET @UpdatedByUser = SYSTEM_USER;

    IF @UpdatedByProgram IS NULL
        SET @UpdatedByProgram = APP_NAME();

    IF @SystemTimestamp IS NULL
        RAISERROR('50001', 16, 1, 'SystemTimestamp') RETURN;

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            [ProjectId] = @ProjectId,
            [ProjectMemberId] = @ProjectMemberId,
            [Name] = @Name,
            [Description] = @Description,
            [StartDate] = @StartDate,
            [TargetDate] = @TargetDate,
            [EndDate] = @EndDate,
            [ProgressStatus] = @ProgressStatus,
            [ActivityPoints] = @ActivityPoints,
            [Priority] = @Priority,
            [Risk] = @Risk,
            [Tags] = @Tags,
            [ActiveFlag] = ISNULL(@ActiveFlag, [ActiveFlag]),
            [SystemDeleteFlag] = ISNULL(@SystemDeleteFlag, [SystemDeleteFlag]),
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE 
            [ActivityId] = @ActivityId
            AND [SystemDeleteFlag] = 'N'
            AND [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('50004', 16, 1, 'Activity') RETURN;
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
