-- usp_ActivityUpdate
CREATE OR ALTER PROCEDURE usp_ActivityUpdate
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    DECLARE @ErrorCode INT = 0;
    DECLARE @ErrorMessage NVARCHAR(4000);

    -- Validate parameters for nullability and types
    IF @ActivityId IS NULL
        RAISERROR('50001', 16, 1, 'ActivityId cannot be null');
    IF @ProjectId IS NULL
        RAISERROR('50001', 16, 1, 'ProjectId cannot be null');
    IF @ProjectMemberId IS NULL
        RAISERROR('50001', 16, 1, 'ProjectMemberId cannot be null');
    IF @Name IS NULL
        RAISERROR('50001', 16, 1, 'Name cannot be null');
    IF @Description IS NULL
        RAISERROR('50001', 16, 1, 'Description cannot be null');

    IF @SystemTimestamp IS NULL
        RAISERROR('50001', 16, 1, 'SystemTimestamp cannot be null');

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            [ProjectId] = @ProjectId,
            [ProjectMemberId] = @ProjectMemberId,
            [Name] = @Name,
            [Description] = @Description,
            [StartDate] = @StartDate,
            [TargetDate] = @TargetDate,
            [EndDate] = @EndDate,
            [ProgressStatus] = @ProgressStatus,
            [ActivityPoints] = @ActivityPoints,
            [Priority] = @Priority,
            [Risk] = @Risk,
            [Tags] = @Tags,
            [UpdatedDateTime] = SYSUTCDATETIME(),
            [UpdatedByUser] = SYSTEM_USER,
            [UpdatedByProgram] = APP_NAME(),
            [SystemTimestamp] = @SystemTimestamp
        WHERE 
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('50004', 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
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
        RAISERROR('50000', 16, 1, 'Error occurred during update');
    END CATCH
END
GO
