-- usp_ActivityUpdate
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
(
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
    @ActiveFlag tinyint = 1,
    @UpdatedDateTime datetime2(7) = SYSUTCDATETIME(),
    @UpdatedByUser nvarchar(100) = SYSTEM_USER,
    @UpdatedByProgram nvarchar(100) = APP_NAME(),
    @SystemTimestamp timestamp
) AS
BEGIN
    -- Input parameter validation
    IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @Name IS NULL OR @Description IS NULL OR @ActiveFlag NOT IN (0, 1)
        THROW 50001, 'Null parameters are not allowed.', 1;
    IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200
        THROW 50002, 'Input string exceeds maximum column length.', 1;

    -- Update statement
    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET [ProjectId] = @ProjectId, [ProjectMemberId] = @ProjectMemberId, [Name] = @Name, [Description] = @Description,
            [StartDate] = @StartDate, [TargetDate] = @TargetDate, [EndDate] = @EndDate, [ProgressStatus] = @ProgressStatus,
            [ActivityPoints] = @ActivityPoints, [Priority] = @Priority, [Risk] = @Risk, [Tags] = @Tags,
            [ActiveFlag] = @ActiveFlag, [UpdatedDateTime] = @UpdatedDateTime, [UpdatedByUser] = @UpdatedByUser, [UpdatedByProgram] = @UpdatedByProgram
        WHERE [ActivityId] = @ActivityId AND [SystemTimestamp] = @SystemTimestamp;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        IF (ERROR_NUMBER() = 2627) BEGIN -- Optimistic lock violation
            RAISERROR ('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);
            THROW 50004, 'Optimistic lock violation.', 1;
        END ELSE BEGIN
            RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
            INSERT INTO [dbo].[DbError] ([ErrorDateTime], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
            VALUES (SYSUTCDATETIME(), ERROR_NUMBER(), @ErrorSeverity, @ErrorState, 'usp_ActivityUpdate', ERROR_LINE(), @ErrorMessage);
            THROW;
        END
    END CATCH
END;
GO