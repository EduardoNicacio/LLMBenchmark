CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000) = NULL,
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint,
    @SystemDeleteFlag char(1),
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp
AS
BEGIN
    -- Validate input parameters
    IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @Name IS NULL
        THROW 50001, 'One or more required parameters are NULL.', 1;

    IF LEN(@Name) > 128
        THROW 50002, 'Parameter Name exceeds maximum length of 128 characters.', 1;

    IF @Description IS NOT NULL AND LEN(@Description) > 4000
        THROW 50002, 'Parameter Description exceeds maximum length of 4000 characters.', 1;

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
        THROW 50002, 'Parameter Tags exceeds maximum length of 200 characters.', 1;

    IF @ActiveFlag NOT IN (0, 1)
        THROW 50003, 'Invalid value for ActiveFlag. Must be either 0 or 1.', 1;

    IF @SystemDeleteFlag NOT IN ('N', 'Y')
        THROW 50003, 'Invalid value for SystemDeleteFlag. Must be either ''N'' or ''Y''.', 1;

    -- Default values for UpdatedDateTime, UpdatedByUser, and UpdatedByProgram
    SET @UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME());
    SET @UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER);
    SET @UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME());

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET ProjectId = @ProjectId,
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
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 1;
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
    END CATCH;
END;
