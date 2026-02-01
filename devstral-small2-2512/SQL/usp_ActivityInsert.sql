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
    BEGIN TRY
        -- Parameter validation
        IF @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL
            RAISERROR('50001: Required parameters cannot be null', 16, 1);

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR (@Tags IS NOT NULL AND LEN(@Tags) > 200)
            RAISERROR('50002: String parameters exceed maximum length', 16, 1);

        IF @ActiveFlag NOT IN (0, 1) OR @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('50003: Invalid value for ActiveFlag or SystemDeleteFlag', 16, 1);

        -- Insert record
        INSERT INTO [dbo].[Activity] (
            [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description],
            [StartDate], [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints],
            [Priority], [Risk], [Tags], [ActiveFlag], [SystemDeleteFlag],
            [CreatedDateTime], [CreatedByUser], [CreatedByProgram]
        )
        VALUES (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description,
            @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints,
            @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
            @CreatedDateTime, @CreatedByUser, @CreatedByProgram
        );
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] ([ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        RAISERROR('50000: Error occurred during insert operation.', 16, 1);
    END CATCH
END
GO
