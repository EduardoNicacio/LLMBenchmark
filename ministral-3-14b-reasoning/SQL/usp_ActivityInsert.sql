CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityInsert]
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000),
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint,
    @SystemDeleteFlag char(1),
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate NOT NULL parameters
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL
            RAISERROR('Required parameter cannot be null', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50001;

        -- Validate string lengths
        IF LEN(ISNULL(@Name, '')) > 128
            RAISERROR('Name exceeds maximum length of 128 characters', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50002;

        IF LEN(ISNULL(@Description, '')) > 4000
            RAISERROR('Description exceeds maximum length of 4000 characters', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50002;

        IF LEN(ISNULL(@Tags, '')) > 200
            RAISERROR('Tags exceed maximum length of 200 characters', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50002;

        -- Validate Created fields (should not be null for insert)
        IF @CreatedDateTime IS NULL OR @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
            RAISERROR('Created fields cannot be null', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50001;

        -- Validate ActiveFlag and SystemDeleteFlag
        IF @ActiveFlag NOT IN (0, 1)
            RAISERROR('ActiveFlag must be 0 or 1', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50003;

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('SystemDeleteFlag must be either "N" or "Y"', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50003;

        -- Insert the record
        INSERT INTO [dbo].[Activity] (
            [ActivityId], [ProjectId], [ProjectMemberId], [Name],
            [Description], [StartDate], [TargetDate], [EndDate],
            [ProgressStatus], [ActivityPoints], [Priority], [Risk],
            [Tags], [ActiveFlag], [SystemDeleteFlag], [CreatedDateTime],
            [CreatedByUser], [CreatedByProgram]
        )
        VALUES (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name,
            @Description, @StartDate, @TargetDate, @EndDate,
            @ProgressStatus, @ActivityPoints, @Priority, @Risk,
            @Tags, @ActiveFlag, @SystemDeleteFlag, @CreatedDateTime,
            @CreatedByUser, @CreatedByProgram
        );

        -- Return success (if needed)
        SELECT 1 AS Result;
    END TRY
    BEGIN CATCH
        -- Log the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState,
            ErrorProcedure, ErrorLine,
            ErrorMessage, CreatedDateTime
        )
        VALUES (
            ERROR_NUMBER(), @ErrorSeverity, @ErrorState,
            'usp_ActivityInsert', ERROR_LINE(),
            @ErrorMessage, SYSUTCDATETIME()
        );

        -- Re-throw the error with our standard message
        RAISERROR('Error occurred during insert operation.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50000;
    END CATCH
END;
GO
