CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000),
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
    @SystemTimestamp varbinary(8)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR 
           @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL OR @SystemTimestamp IS NULL
        BEGIN
            RAISERROR('Required parameter is null.', 16, 50001);
            RETURN;
        END

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR 
           (@UpdatedByUser IS NOT NULL AND LEN(@UpdatedByUser) > 100) OR 
           (@UpdatedByProgram IS NOT NULL AND LEN(@UpdatedByProgram) > 100)
        BEGIN
            RAISERROR('String parameter exceeds column length.', 16, 50002);
            RETURN;
        END

        IF @ActiveFlag NOT IN (0, 1)
        BEGIN
            RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.', 16, 50003);
            RETURN;
        END

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
        BEGIN
            RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 50003);
            RETURN;
        END

        -- Default values if not provided
        IF @UpdatedDateTime IS NULL THEN SET @UpdatedDateTime = SYSUTCDATETIME();
        IF @UpdatedByUser IS NULL THEN SET @UpdatedByUser = SYSTEM_USER;
        IF @UpdatedByProgram IS NULL THEN SET @UpdatedByProgram = APP_NAME();

        -- Update the activity record with optimistic locking
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
        WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Log error to dbo.DbError table
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during update operation.', 16, 50000);
    END CATCH
END;
GO
