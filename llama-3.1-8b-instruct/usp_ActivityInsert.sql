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
    @ActiveFlag TINYINT = NULL,
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100),
    @CreatedDateTime DATETIME2(7) = SYSUTCDATETIME()
AS
BEGIN
    SET NOCOUNT ON;

    IF @ActivityId IS NULL RAISERROR('50001', 16, 1);
    IF LEN(@Name) > 128 RAISERROR('50002', 16, 1);
    IF LEN(@Description) > 4000 RAISERROR('50002', 16, 1);
    IF LEN(@Tags) > 200 RAISERROR('50002', 16, 1);
    IF (LEN(@ProjectId) != 36 OR @ProjectMemberId IS NULL OR LEN(@ProjectMemberId) != 36 OR
       LEN(@CreatedByUser) > 100 OR LEN(@CreatedByProgram) > 100 OR
       (@ActiveFlag IS NOT NULL AND (@ActiveFlag != 1)))
    RAISERROR('50003', 16, 1);

    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
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
            CreatedByUser,
            CreatedByProgram,
            CreatedDateTime
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
            @CreatedByUser,
            @CreatedByProgram,
            @CreatedDateTime
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
        RAISERROR('50000', 16, 1, 'Error occurred during INSERT operation.');
    END CATCH;
END
GO