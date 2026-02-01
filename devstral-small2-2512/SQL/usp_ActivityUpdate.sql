CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @ActiveFlag TINYINT,
    @SystemDeleteFlag CHAR(1),
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp VARBINARY(8)
AS
BEGIN
    BEGIN TRY
        -- Parameter validation
        IF @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL
            RAISERROR('50001: Required parameters cannot be null', 16, 1);

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR (@Tags IS NOT NULL AND LEN(@Tags) > 200)
            RAISERROR('50002: String parameters exceed maximum length', 16, 1);

        IF @ActiveFlag NOT IN (0, 1) OR @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('50003: Invalid value for ActiveFlag or SystemDeleteFlag', 16, 1);

        -- Set default values if null
        SET @UpdatedDateTime = ISNULL(@UpdatedDateTime, SYSUTCDATETIME());
        SET @UpdatedByUser = ISNULL(@UpdatedByUser, SYSTEM_USER);
        SET @UpdatedByProgram = ISNULL(@UpdatedByProgram, APP_NAME());

        -- Update with optimistic locking
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
            [ActiveFlag] = @ActiveFlag,
            [SystemDeleteFlag] = @SystemDeleteFlag,
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE
            [ActivityId] = @ActivityId AND
            [SystemTimestamp] = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('50004: Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1);
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] ([ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        RAISERROR('50000: Error occurred during update operation.', 16, 1);
    END CATCH
END
GO
