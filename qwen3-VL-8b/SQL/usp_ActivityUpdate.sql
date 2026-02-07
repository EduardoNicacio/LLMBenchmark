CREATE PROCEDURE usp_ActivityUpdate
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
    @ActiveFlag TINYINT = NULL,
    @SystemDeleteFlag CHAR(1) = NULL,
    @UpdatedDateTime DATETIME2(7),
    @UpdatedByUser NVARCHAR(100),
    @UpdatedByProgram NVARCHAR(100),
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF (@ActivityId IS NULL)
        RAISERROR('Error 50001: ActivityId cannot be null.', 16, 1);
    IF (@UpdatedDateTime IS NULL)
        SET @UpdatedDateTime = SYSUTCDATETIME();
    IF (@UpdatedByUser IS NULL)
        SET @UpdatedByUser = SYSTEM_USER;
    IF (@UpdatedByProgram IS NULL)
        SET @UpdatedByProgram = APP_NAME();

    -- Validate string parameters
    IF (LEN(@UpdatedByUser) > 100)
        RAISERROR('Error 50002: UpdatedByUser exceeds maximum length of 100 characters.', 16, 1);
    IF (LEN(@UpdatedByProgram) > 100)
        RAISERROR('Error 50002: UpdatedByProgram exceeds maximum length of 100 characters.', 16, 1);

    -- Validate ActiveFlag and SystemDeleteFlag
    IF (@ActiveFlag IS NOT NULL AND @ActiveFlag NOT IN (0, 1))
        RAISERROR('Error 50003: ActiveFlag must be 0 or 1.', 16, 1);
    IF (@SystemDeleteFlag IS NOT NULL AND @SystemDeleteFlag NOT IN ('N', 'Y'))
        RAISERROR('Error 50003: SystemDeleteFlag must be ''N'' or ''Y''.', 16, 1);

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
            [ActiveFlag] = ISNULL(@ActiveFlag, [ActiveFlag]),
            [SystemDeleteFlag] = ISNULL(@SystemDeleteFlag, [SystemDeleteFlag]),
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram,
            [SystemTimestamp] = @SystemTimestamp
        WHERE
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('Error 50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);

        -- Success
        SELECT 1 AS Result;
    END TRY
    BEGIN CATCH
        -- Log error
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorTime)
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            GETUTCDATE()
        );

        -- Raise error
        RAISERROR('Error 50000: Error occurred during ActivityUpdate operation.', 16, 1);
    END CATCH
END;
GO
