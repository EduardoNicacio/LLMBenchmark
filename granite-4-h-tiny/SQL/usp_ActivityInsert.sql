CREATE PROCEDURE usp_ActivityInsert
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE,
    @TargetDate DATE,
    @EndDate DATE,
    @ProgressStatus TINYINT,
    @ActivityPoints SMALLINT,
    @Priority TINYINT,
    @Risk TINYINT,
    @Tags NVARCHAR(200),
    @ActiveFlag TINYINT = 1, -- Default to active
    @SystemDeleteFlag CHAR(1) = 'N', -- Default to not deleted
    @CreatedDateTime DATETIME2,
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM sysobjects WHERE name='usp_ActivityInsert' AND xtype='PC')
        EXEC('DROP PROCEDURE usp_ActivityInsert');

    CREATE PROC usp_ActivityInsert AS

    BEGIN TRY
        INSERT INTO [dbo].[Activity](
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
            ISNULL(@CreatedDateTime, GETDATE()),
            ISNULL(@CreatedByUser, SYSTEM_USER),
            ISNULL(@CreatedByProgram, APP_NAME())
        );

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'YourProfileName',
            @recipients = 'your@email.com',
            @subject = 'Error in usp_ActivityInsert',
            @body = 'An error occurred: ' + @ErrorMessage;

        RAISERROR('Error occurred during insert operation.', 16, 1);
    END CATCH;
END;
GO
