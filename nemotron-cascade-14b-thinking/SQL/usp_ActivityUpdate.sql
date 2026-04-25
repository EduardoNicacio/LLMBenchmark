-- usp_ActivityUpdate
CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
(
    -- Input parameters: All columns except CreatedDateTime, CreatedByUser, CreatedByProgram
    @ActivityId UNIQUEIDENTIFIER NOT NULL,
    @ProjectId UNIQUEIDENTIFIER NOT NULL,
    @ProjectMemberId UNIQUEIDENTIFIER NOT NULL,
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
    @ActiveFlag TINYINT NOT NULL,
    @SystemDeleteFlag CHAR(1) NOT NULL,
    -- Excluded: CreatedDateTime, CreatedByUser, CreatedByProgram
    @UpdatedDateTime DATETIME2(7) = NULL,
    @UpdatedByUser NVARCHAR(100) = NULL,
    @UpdatedByProgram NVARCHAR(100) = NULL,
    @SystemTimestamp TIMESTAMP NOT NULL
)
AS
BEGIN
    -- Validate null parameters for non-nullable columns
    IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR 
       @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR 
       @SystemDeleteFlag IS NULL OR @SystemTimestamp IS NULL THEN
        BEGIN RAISERROR('Error 50001: Null parameter detected.', 16, 50001); RETURN; END

    -- Validate string lengths
    IF LEN(@Name) > 128 BEGIN RAISERROR('Error 50002: Name exceeds column length.', 16, 50002); RETURN; END
    IF LEN(@Description) > 4000 BEGIN RAISERROR('Error 50002: Description exceeds column length.', 16, 50002); RETURN; END
    IF LEN(@Tags) > 200 BEGIN RAISERROR('Error 50002: Tags exceeds column length.', 16, 50002); RETURN; END

    -- Validate ActiveFlag and SystemDeleteFlag values
    IF @ActiveFlag NOT IN (0, 1) BEGIN RAISERROR('Error 50003: Invalid ActiveFlag value.', 16, 50003); RETURN; END
    IF @SystemDeleteFlag NOT IN ('N', 'Y') BEGIN RAISERROR('Error 50003: Invalid SystemDeleteFlag value.', 16, 50003); RETURN; END

    BEGIN TRY
        -- Optimistic lock check
        DECLARE @CurrentSystemTimestamp TIMESTAMP;
        SELECT @CurrentSystemTimestamp = SystemTimestamp FROM [dbo].[Activity] WHERE ActivityId = @ActivityId;

        IF @CurrentSystemTimestamp <> @SystemTimestamp
        BEGIN
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);
            RETURN;
        END

        -- Update with default values for update fields if null
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
            UpdatedDateTime = COALESCE(@UpdatedDateTime, SYSUTCDATETIME()),
            UpdatedByUser = COALESCE(@UpdatedByUser, SYSTEM_USER),
            UpdatedByProgram = COALESCE(@UpdatedByProgram, APP_NAME());
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (ErrorDateTime, ErrorLevel, ErrorNumber, Message, ConnectionId)
        VALUES (GETDATE(), 1, ERROR_NUMBER(), ERROR_MESSAGE(), @@CONNECTION_ID());
        RAISERROR('Error occurred during Update operation.', 16, 50000);
    END CATCH
END
GO