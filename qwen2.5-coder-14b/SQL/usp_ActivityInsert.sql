-- usp_ActivityInsert

CREATE PROCEDURE [dbo].[usp_ActivityInsert]
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
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N',
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN
    BEGIN TRY
        -- Validate input parameters
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @Name IS NULL 
           OR @Description IS NULL OR @CreatedDateTime IS NULL OR @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
            RAISERROR('Error 50001: Null parameter(s) detected.', 16, 1);

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR LEN(@CreatedByUser) > 100 OR LEN(@CreatedByProgram) > 100
            RAISERROR('Error 50002: String parameter exceeds column length.', 16, 1);

        IF @ActiveFlag NOT IN (0, 1)
            RAISERROR('Error 50003: Invalid ActiveFlag value. Must be 0 or 1.', 16, 1);

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('Error 50003: Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 1);

        -- Insert the new activity
        INSERT INTO [dbo].[Activity] (
            [ActivityId],
            [ProjectId],
            [ProjectMemberId],
            [Name],
            [Description],
            [StartDate],
            [TargetDate],
            [EndDate],
            [ProgressStatus],
            [ActivityPoints],
            [Priority],
            [Risk],
            [Tags],
            [ActiveFlag],
            [SystemDeleteFlag],
            [CreatedDateTime],
            [CreatedByUser],
            [CreatedByProgram]
        ) VALUES (
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
        -- Log the error to dbo.DbError table
        INSERT INTO [dbo].[DbError] (
            ErrorMessage,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorNumber
        ) VALUES (
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_NUMBER()
        );

        -- Raise a generic error message
        RAISERROR('Error 50000: Error occurred during Insert operation.', 16, 1);
    END CATCH
END;
GO