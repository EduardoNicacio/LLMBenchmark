-- usp_[Entity]Insert - Insert stored procedure

CREATE PROCEDURE [dbo].[usp_ActivityInsert]
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000) = NULL,
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

    BEGIN TRY
        -- Validate input parameters for null values and types/sizes
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR 
           @Name IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL OR 
           @CreatedDateTime IS NULL OR @CreatedByUser IS NULL OR @CreatedByProgram IS NULL THEN
            RAISERROR ('50001: Required parameters cannot be null', 16, 1);

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR LEN(@CreatedByUser) > 100 OR LEN(@CreatedByProgram) > 100 THEN
            RAISERROR ('50002: Parameter length exceeds column size', 16, 1);

        IF @ActiveFlag <> 0 AND @ActiveFlag <> 1 THEN
            RAISERROR ('50003: ActiveFlag must be either 0 or 1', 16, 1);

        IF @SystemDeleteFlag NOT IN ('N', 'Y') THEN
            RAISERROR ('50003: SystemDeletedFlag must be either N or Y', 16, 1);

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
            SystemDeleteFlag,
            CreatedDateTime,
            CreatedByUser,
            CreatedByProgram
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
        -- Log the error in the table DbError
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
    END CATCH;
END;