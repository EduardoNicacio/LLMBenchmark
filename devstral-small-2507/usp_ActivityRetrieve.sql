-- usp_[Entity]Retrieve - Retrieve stored procedure

CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
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
    @SystemDeleteFlag CHAR(1) = 'N',
    @CreatedDateTime DATETIME2(7) = NULL,
    @CreatedByUser NVARCHAR(100) = NULL,
    @CreatedByProgram NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters for null values and types/sizes
        IF (@ActiveFlag IS NOT NULL AND @ActiveFlag <> 0 AND @ActiveFlag <> 1) THEN
            RAISERROR ('50003: ActiveFlag must be either 0 or 1', 16, 1);

        IF (@SystemDeleteFlag IS NOT NULL AND @SystemDeleteFlag NOT IN ('N', 'Y')) THEN
            RAISERROR ('50003: SystemDeletedFlag must be either N or Y', 16, 1);

        SELECT * FROM [dbo].[Activity]
        WHERE
            (@ActivityId IS NULL OR ActivityId = @ActivityId) AND
            (@ProjectId IS NULL OR ProjectId = @ProjectId) AND
            (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId) AND
            (@Name IS NULL OR Name LIKE '%' + @Name + '%') AND
            (@Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0) AND
            (@StartDate IS NULL OR StartDate = @StartDate) AND
            (@TargetDate IS NULL OR TargetDate = @TargetDate) AND
            (@EndDate IS NULL OR EndDate = @EndDate) AND
            (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus) AND
            (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints) AND
            (@Priority IS NULL OR Priority = @Priority) AND
            (@Risk IS NULL OR Risk = @Risk) AND
            (@Tags IS NULL OR Tags LIKE '%' + @Tags + '%') AND
            ActiveFlag = @ActiveFlag AND
            SystemDeleteFlag = @SystemDeleteFlag;
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