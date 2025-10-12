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
    @ActiveFlag TINYINT,
    @SystemDeleteFlag CHAR(1),
    @CreatedDateTime DATETIME2(7),
    @CreatedByUser NVARCHAR(100),
    @CreatedByProgram NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Parameter Validation
    IF @ActiveFlag NOT IN (0, 1) OR @SystemDeleteFlag NOT IN ('N', 'Y')
        THROW 50003, 'Invalid flag parameter.', 1;

    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
            [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description],
            [StartDate], [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints],
            [Priority], [Risk], [Tags], [ActiveFlag], [SystemDeleteFlag],
            [CreatedDateTime], [CreatedByUser], [CreatedByProgram], [SystemTimestamp]
        )
        VALUES (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description,
            @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints,
            @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
            @CreatedDateTime, @CreatedByUser, @CreatedByProgram, 0x0
        );
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
        )
        VALUES (
            ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE()
        );
        THROW 50000, 'Error occurred during INSERT operation.', 1;
    END CATCH;
END;
GO