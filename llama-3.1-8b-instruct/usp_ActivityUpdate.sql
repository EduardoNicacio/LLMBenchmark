-- usp_ActivityUpdate
CREATE PROCEDURE usp_ActivityUpdate
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
    @ActiveFlag TINYINT = NULL,
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    IF @ActivityId IS NULL RAISERROR('50001', 16, 1);
    IF LEN(@Name) > 128 RAISERROR('50002', 16, 1);
    IF LEN(@Description) > 4000 RAISERROR('50002', 16, 1);
    IF LEN(@Tags) > 200 RAISERROR('50002', 16, 1);
    IF (LEN(@ProjectId) != 36 OR @ProjectMemberId IS NULL OR LEN(@ProjectMemberId) != 36 OR
       LEN(@UpdatedByUser) > 100 OR LEN(@UpdatedByProgram) > 100 OR
       (@ActiveFlag IS NOT NULL AND (@ActiveFlag != 1)))
    RAISERROR('50003', 16, 1);

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            ActivityId = @ActivityId,
            ProjectId = @ProjectId,
            ProjectMemberId = @ProjectMemberId,
            Name = @Name,
            Description = @Description,
            StartDate = @StartDate,
            TargetDate = @TargetDate,
            EndDate = @EndDate,
            ProgressStatus = @ProgressStatus,
            ActivityPoints = @ActivityPoints,
            Priority = @Priority,
            Risk = @Risk,
            Tags = @Tags,
            ActiveFlag = COALESCE(@ActiveFlag, (SELECT ActiveFlag FROM [dbo].[Activity] WHERE ActivityId = @ActivityId)),
            UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

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
        IF EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemTimestamp != @SystemTimestamp)
        RAISERROR('50004', 16, 1);
        ELSE
        RAISERROR('50000', 16, 1, 'Error occurred during UPDATE operation.');
    END CATCH;
END
GO