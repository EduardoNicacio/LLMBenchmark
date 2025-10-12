-- usp_[Entity]Update - Update stored procedure

CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp VARBINARY(8)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters for null values and types/sizes
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR 
           @Name IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL THEN
            RAISERROR ('50001: Required parameters cannot be null', 16, 1);

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR 
           (@UpdatedByUser IS NOT NULL AND LEN(@UpdatedByUser) > 100) OR 
           (@UpdatedByProgram IS NOT NULL AND LEN(@UpdatedByProgram) > 100) THEN
            RAISERROR ('50002: Parameter length exceeds column size', 16, 1);

        IF @ActiveFlag <> 0 AND @ActiveFlag <> 1 THEN
            RAISERROR ('50003: ActiveFlag must be either 0 or 1', 16, 1);

        IF @SystemDeleteFlag NOT IN ('N', 'Y') THEN
            RAISERROR ('50003: SystemDeletedFlag must be either N or Y', 16, 1);

        -- Set default values if null
        IF @UpdatedDateTime IS NULL THEN
            SET @UpdatedDateTime = SYSUTCDATETIME();

        IF @UpdatedByUser IS NULL THEN
            SET @UpdatedByUser = SYSTEM_USER;

        IF @UpdatedByProgram IS NULL THEN 
            SET @UpdatedByProgram = APP_NAME();

        -- Perform update with optimistic lock verification
        UPDATE [dbo].[Activity]
        SET
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
            ActiveFlag = @ActiveFlag,
            SystemDeleteFlag = @SystemDeleteFlag,
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0 THEN
            RAISERROR ('50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);
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