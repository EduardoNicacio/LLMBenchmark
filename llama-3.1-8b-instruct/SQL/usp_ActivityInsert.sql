-- usp_ActivityInsert
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
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
    @ActiveFlag TINYINT = 1,
    @SystemDeleteFlag CHAR(1) = 'N',
    @CreatedDateTime DATETIME2(7) = SYSUTCDATETIME(),
    @CreatedByUser NVARCHAR(100) = SYSTEM_USER,
    @CreatedByProgram NVARCHAR(100) = APP_NAME()
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF (@ActivityId IS NULL)
            RAISERROR('Parameter ActivityId cannot be null.', 16, 1);

        IF (@ProjectId IS NULL)
            RAISERROR('Parameter ProjectId cannot be null.', 16, 1);

        IF (@ProjectMemberId IS NULL)
            RAISERROR('Parameter ProjectMemberId cannot be null.', 16, 1);

        IF (LEN(@Name) > 128)
            RAISERROR('String parameter Name exceeds column length of 128.', 16, 1);

        IF (LEN(@Description) > 4000)
            RAISERROR('String parameter Description exceeds column length of 4000.', 16, 1);

        IF (LEN(@Tags) > 200)
            RAISERROR('String parameter Tags exceeds column length of 200.', 16, 1);

        IF (@ActiveFlag NOT IN (0, 1))
            RAISERROR('Invalid value for ActiveFlag. Please specify 0 or 1.', 16, 1);

        IF (@SystemDeleteFlag NOT IN ('N', 'Y'))
            RAISERROR('Invalid value for SystemDeleteFlag. Please specify ''N'' or ''Y''.', 16, 1);

        INSERT INTO [dbo].[Activity] (
            ActivityId,
            ProjectId,
            ProjectMemberId,
            Name,
            Description,
            StartDate,
            TargetDate,
            EndDate,
            ProgressStatus,
            ActivityPoints,
            Priority,
            Risk,
            Tags,
            ActiveFlag,
            SystemDeleteFlag,
            CreatedDateTime,
            CreatedByUser,
            CreatedByProgram
        )
        VALUES (
            @ActivityId,
            @ProjectId,
            @ProjectMemberId,
            @Name,
            @Description,
            @StartDate,
            @TargetDate,
            @EndDate,
            @ProgressStatus,
            @ActivityPoints,
            @Priority,
            @Risk,
            @Tags,
            @ActiveFlag,
            @SystemDeleteFlag,
            @CreatedDateTime,
            @CreatedByUser,
            @CreatedByProgram
        );

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = 'Error occurred during Insert operation.';
        INSERT INTO [dbo].[DbError] (ErrorMessage, ErrorDate) VALUES (@ErrorMessage, SYSUTCDATETIME());

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, 16, 1);

    END CATCH;
END;
GO