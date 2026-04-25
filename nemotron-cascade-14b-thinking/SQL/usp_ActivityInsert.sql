-- usp_ActivityInsert
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
    (
    -- Input parameters (all except UpdatedDateTime, UpdatedByUser, UpdatedByProgram, SystemTimestamp)
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
    @CreatedDateTime DATETIME2(7) NOT NULL,
    @CreatedByUser NVARCHAR(100) NOT NULL,
    @CreatedByProgram NVARCHAR(100) NOT NULL
)
AS
BEGIN
    -- Validate null parameters for non-nullable columns
    IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR
        @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR
        @SystemDeleteFlag IS NULL OR @CreatedDateTime IS NULL OR
        @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
    BEGIN
        RAISERROR('Error 50001: Null parameter detected.', 16, 50001);
        RETURN;
    END

    -- Validate string lengths
    IF LEN(@Name) > 128 BEGIN
        RAISERROR('Error 50002: Name exceeds column length.', 16, 50002);
        RETURN;
    END
    IF LEN(@Description) > 4000 BEGIN
        RAISERROR('Error 50002: Description exceeds column length.', 16, 50002);
        RETURN;
    END
    IF LEN(@Tags) > 200 BEGIN
        RAISERROR('Error 50002: Tags exceeds column length.', 16, 50002);
        RETURN;
    END

    -- Validate ActiveFlag and SystemDeleteFlag values
    IF @ActiveFlag NOT IN (0, 1) BEGIN
        RAISERROR('Error 50003: Invalid ActiveFlag value.', 16, 50003);
        RETURN;
    END
    IF @SystemDeleteFlag NOT IN ('N', 'Y') BEGIN
        RAISERROR('Error 50003: Invalid SystemDeleteFlag value.', 16, 50003);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO [dbo].[Activity]
        (
        ActivityId, ProjectId, ProjectMemberId, Name, Description, StartDate, TargetDate, EndDate,
        ProgressStatus, ActivityPoints, Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag,
        CreatedDateTime, CreatedByUser, CreatedByProgram, UpdatedDateTime, UpdatedByUser, UpdatedByProgram, SystemTimestamp
        )
    VALUES
        (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description, @StartDate, @TargetDate, @EndDate,
            @ProgressStatus, @ActivityPoints, @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
            @CreatedDateTime, @CreatedByUser, @CreatedByProgram,
            SYSUTCDATETIME(), SYSTEM_USER, APP_NAME(), CAST(GETDATE() AS timestamp)
        );
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError]
        (ErrorDateTime, ErrorLevel, ErrorNumber, Message, ConnectionId)
    VALUES
        (GETDATE(), 1, ERROR_NUMBER(), ERROR_MESSAGE(), @@CONNECTION_ID());
        RAISERROR('Error occurred during Insert operation.', 16, 50000);
    END CATCH
END
GO