-- usp_ActivityUpdate

CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N',
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp timestamp
AS
BEGIN
    BEGIN TRY
        -- Validate input parameters
        IF @ActivityId IS NULL OR @SystemTimestamp IS NULL
            RAISERROR('Error 50001: Null parameter(s) detected.', 16, 1);

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR LEN(@UpdatedByUser) > 100 OR LEN(@UpdatedByProgram) > 100
            RAISERROR('Error 50002: String parameter exceeds column length.', 16, 1);

        IF @ActiveFlag NOT IN (0, 1)
            RAISERROR('Error 50003: Invalid ActiveFlag value. Must be 0 or 1.', 16, 1);

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('Error 50003: Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 1);

        -- Default UpdatedDateTime, UpdatedByUser, and UpdatedByProgram if null
        IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
        IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
        IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

        -- Update the activity
        UPDATE [dbo].[Activity]
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
            ActiveFlag = ISNULL(@ActiveFlag, ActiveFlag),
            SystemDeleteFlag = ISNULL(@SystemDeleteFlag, SystemDeleteFlag),
            UpdatedDateTime = @UpdatedDateTime,
            UpdatedByUser = @UpdatedByUser,
            UpdatedByProgram = @UpdatedByProgram
        WHERE 
            ActivityId = @ActivityId AND
            [SystemTimestamp] = @SystemTimestamp;

        -- Check for optimistic lock violation
        IF @@ROWCOUNT = 0
            RAISERROR('Error 50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);

    END TRY
    BEGIN CATCH
        -- Log the error to dbo.DbError table
        INSERT INTO [dbo].[DbError] (
            ErrorMessage,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorNumber
        ) VALUES (
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_NUMBER()
        );

        -- Raise a generic error message
        RAISERROR('Error 50000: Error occurred during Update operation.', 16, 1);
    END CATCH
END;
GO