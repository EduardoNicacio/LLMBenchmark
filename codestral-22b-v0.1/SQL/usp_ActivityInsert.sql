-- usp_ActivityInsert
CREATE PROCEDURE [dbo].[usp_ActivityInsert]
(
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
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
) AS
BEGIN
    -- Input parameter validation
    IF @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @Name IS NULL OR @Description IS NULL OR @ActiveFlag NOT IN (0, 1)
        THROW 50001, 'Null parameters are not allowed.', 1;
    IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200
        THROW 50002, 'Input string exceeds maximum column length.', 1;

    -- Insert statement
    BEGIN TRY
        INSERT INTO [dbo].[Activity] (
            [ActivityId], [ProjectId], [ProjectMemberId], [Name], [Description], [StartDate],
            [TargetDate], [EndDate], [ProgressStatus], [ActivityPoints], [Priority], [Risk],
            [Tags], [ActiveFlag], [SystemDeleteFlag], [CreatedDateTime], [CreatedByUser],
            [CreatedByProgram], [UpdatedDateTime], [UpdatedByUser], [UpdatedByProgram]
        ) VALUES (
            NEWID(), @ProjectId, @ProjectMemberId, @Name, @Description, @StartDate,
            @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints, @Priority, @Risk,
            @Tags, @ActiveFlag, 'N', @CreatedDateTime, @CreatedByUser, @CreatedByProgram, NULL, NULL, NULL
        );
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        INSERT INTO [dbo].[DbError] ([ErrorDateTime], [ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (SYSUTCDATETIME(), ERROR_NUMBER(), @ErrorSeverity, @ErrorState, 'usp_ActivityInsert', ERROR_LINE(), @ErrorMessage);
        THROW;
    END CATCH
END;
GO