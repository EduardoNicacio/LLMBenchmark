CREATE PROCEDURE usp_ActivityUpdate
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier = NULL,
    @ProjectMemberId uniqueidentifier = NULL,
    @Name nvarchar(128) = NULL,
    @Description nvarchar(4000) = NULL,
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = NULL, -- Can be null to preserve original value
    @SystemDeleteFlag char(1) = 'N', -- Default to 'N'
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @CurrentSystemTimestamp rowversion -- Optimistic lock column
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Parameter validation: ActivityId cannot be null
        IF @ActivityId IS NULL
            THROW 50001, 'Null parameter detected.', 1;
            
        DECLARE @CurrentSystemTimestamp rowversion;
        SELECT @CurrentSystemTimestamp = SystemTimestamp FROM dbo.Activity WHERE ActivityId = @ActivityId AND SystemDeleteFlag = 'N';
        
        IF @CurrentSystemTimestamp IS NULL
            THROW 50001, 'Activity not found or already deleted.', 1;
            
        -- Update record with null defaults for optional parameters
        UPDATE dbo.Activity
        SET 
            ProjectId = ISNULL(@ProjectId, ProjectId),
            ProjectMemberId = ISNULL(@ProjectMemberId, ProjectMemberId),
            Name = ISNULL(@Name, Name),
            Description = ISNULL(@Description, Description),
            StartDate = ISNULL(@StartDate, StartDate),
            TargetDate = ISNULL(@TargetDate, TargetDate),
            EndDate = ISNULL(@EndDate, EndDate),
            ProgressStatus = ISNULL(@ProgressStatus, ProgressStatus),
            ActivityPoints = ISNULL(@ActivityPoints, ActivityPoints),
            Priority = ISNULL(@Priority, Priority),
            Risk = ISNULL(@Risk, Risk),
            Tags = ISNULL(@Tags, Tags),
            ActiveFlag = ISNULL(@ActiveFlag, ActiveFlag), -- Preserve original if null
            SystemDeleteFlag = @SystemDeleteFlag,
            UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME())
        WHERE ActivityId = @ActivityId
          AND SystemTimestamp = @CurrentSystemTimestamp; -- Optimistic lock check
        
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorTime)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), SYSDATETIME());
        
        IF ERROR_NUMBER() = 5131 -- Optimistic lock violation
            THROW 50004, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 1;
            
        ELSE
            THROW 50000, 'Error occurred during Update operation.', 1;
    END CATCH
END
GO