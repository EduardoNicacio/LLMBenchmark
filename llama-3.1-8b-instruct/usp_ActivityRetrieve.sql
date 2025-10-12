-- usp_ActivityRetrieve
CREATE PROCEDURE usp_ActivityRetrieve
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(128) = NULL,
    @Description NVARCHAR(4000) = NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1,
    @SystemDeletedFlag CHAR(1) = 'N'
AS
BEGIN
    SET NOCOUNT ON;

    IF (@ActiveFlag IS NOT NULL AND (@ActiveFlag != 0 AND @ActiveFlag != 1))
    RAISERROR('50003', 16, 1);
    IF (LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200)
    RAISERROR('50002', 16, 1);

    BEGIN TRY
        SELECT 
            ActivityId,
            ProjectId,
            ProjectMemberId,
            Name,
            Description,
            StartDate,
            TargetDate,
            EndDate,
            ProgressStatus,
            ActivityPoints,
            Priority,
            Risk,
            Tags,
            ActiveFlag,
            SystemDeleteFlag,
            CreatedDateTime,
            CreatedByUser,
            CreatedByProgram,
            UpdatedDateTime,
            UpdatedByUser,
            UpdatedByProgram
        FROM [dbo].[Activity]
        WHERE 
            (@ActivityId IS NULL OR ActivityId = @ActivityId) AND
            (@ProjectId IS NULL OR ProjectId = @ProjectId) AND
            (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId) AND
            (@Name IS NULL OR CHARINDEX(@Name, Name, 0) > 0) AND
            (@Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0) AND
            (@StartDate IS NULL OR (StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate))) AND
            (@TargetDate IS NULL OR (TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate))) AND
            (@EndDate IS NULL OR (EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate))) AND
            (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus) AND
            (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints) AND
            (@Priority IS NULL OR Priority = @Priority) AND
            (@Risk IS NULL OR Risk = @Risk) AND
            (@Tags IS NULL OR CHARINDEX(@Tags, Tags, 0) > 0) AND
            (ActiveFlag = 1 OR ActiveFlag = @ActiveFlag) AND
            (SystemDeleteFlag = 'N' OR SystemDeletedFlag = @SystemDeletedFlag);

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
        RAISERROR('50000', 16, 1, 'Error occurred during RETRIEVE operation.');
    END CATCH;
END
GO