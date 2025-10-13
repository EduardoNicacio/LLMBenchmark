-- usp_ActivityInsert
CREATE PROCEDURE dbo.usp_ActivityInsert
(
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000) = NULL,
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
    @CreatedDateTime DATETIME2(7),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Input validation
        IF dbo.CheckInputParameter(@ActivityId, NULL, 0, 'ActivityId') = 1 RETURN;
        IF dbo.CheckInputParameter(@ProjectId, NULL, 0, 'ProjectId') = 1 RETURN;
        IF dbo.CheckInputParameter(@ProjectMemberId, NULL, 0, 'ProjectMemberId') = 1 RETURN;
        IF dbo.CheckInputParameter(@Name, 128, 0, 'Name') = 1 RETURN;
        IF dbo.CheckInputParameter(@Description, 4000, 1, 'Description') = 1 RETURN;
        IF dbo.CheckInputParameter(@Tags, 200, 1, 'Tags') = 1 RETURN;
        IF dbo.CheckInputParameter(@CreatedByUser, 100, 0, 'CreatedByUser') = 1 RETURN;
        IF dbo.CheckInputParameter(@CreatedByProgram, 100, 0, 'CreatedByProgram') = 1 RETURN;

        IF @ActiveFlag NOT IN (0, 1)
            RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.', 16, 50003);
        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 50003);

        INSERT INTO [dbo].[Activity](
            [ActivityId], [ProjectId], [ProjectMemberId], [Name],
            [Description], [StartDate], [TargetDate], [EndDate],
            [ProgressStatus], [ActivityPoints], [Priority], [Risk],
            [Tags], [ActiveFlag], [SystemDeleteFlag],
            [CreatedDateTime], [CreatedByUser], [CreatedByProgram]
        ) VALUES (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name,
            @Description, @StartDate, @TargetDate, @EndDate,
            @ProgressStatus, @ActivityPoints, @Priority, @Risk,
            @Tags, @ActiveFlag, @SystemDeleteFlag,
            @CreatedDateTime, @CreatedByUser, @CreatedByProgram
        );

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        EXEC dbo.LogError @ErrorMessage, @ErrorSeverity, @ErrorState, 'usp_ActivityInsert';

        RAISERROR('Error occurred during Activity insert operation.', 16, 50000);
    END CATCH
END
GO
