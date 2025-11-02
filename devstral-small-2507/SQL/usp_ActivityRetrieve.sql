CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
    @Parameter nvarchar(4000) = NULL,
    @DateTimeParameter datetime2(7) = NULL,
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters
        IF @ActiveFlag NOT IN (0, 1)
        BEGIN
            RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.', 16, 50003);
            RETURN;
        END

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
        BEGIN
            RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 50003);
            RETURN;
        END

        -- Retrieve activity records with wildcard search and date range search
        SELECT * FROM [dbo].[Activity]
        WHERE (@Parameter IS NULL OR 
               CHARINDEX(@Parameter, [ActivityId], 0) > 0 OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(128), [ProjectId]), 0) > 0 OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(128), [ProjectMemberId]), 0) > 0 OR 
               CHARINDEX(@Parameter, [Name], 0) > 0 OR 
               CHARINDEX(@Parameter, [Description], 0) > 0 OR 
               (@StartDate IS NOT NULL AND CHARINDEX(@Parameter, CONVERT(nvarchar(50), [StartDate]), 0) > 0) OR 
               (@TargetDate IS NOT NULL AND CHARINDEX(@Parameter, CONVERT(nvarchar(50), [TargetDate]), 0) > 0) OR 
               (@EndDate IS NOT NULL AND CHARINDEX(@Parameter, CONVERT(nvarchar(50), [EndDate]), 0) > 0) OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(3), [ProgressStatus]), 0) > 0 OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(6), [ActivityPoints]), 0) > 0 OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(3), [Priority]), 0) > 0 OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(3), [Risk]), 0) > 0 OR 
               CHARINDEX(@Parameter, [Tags], 0) > 0 OR 
               CHARINDEX(@Parameter, CONVERT(nvarchar(1), [ActiveFlag]), 0) > 0 OR 
               CHARINDEX(@Parameter, [SystemDeleteFlag], 0) > 0 OR 
               CHARINDEX(@Parameter, [CreatedByUser], 0) > 0 OR 
               CHARINDEX(@Parameter, [CreatedByProgram], 0) > 0 OR 
               (@UpdatedDateTime IS NOT NULL AND CHARINDEX(@Parameter, CONVERT(nvarchar(50), [UpdatedDateTime]), 0) > 0) OR 
               (@UpdatedByUser IS NOT NULL AND CHARINDEX(@Parameter, [UpdatedByUser], 0) > 0) OR 
               (@UpdatedByProgram IS NOT NULL AND CHARINDEX(@Parameter, [UpdatedByProgram], 0) > 0)) AND
              (ActiveFlag = @ActiveFlag) AND
              (SystemDeleteFlag = @SystemDeleteFlag) AND
              (@DateTimeParameter IS NULL OR
               (CreatedDateTime >= @DateTimeParameter AND CreatedDateTime < DATEADD(day, 1, @DateTimeParameter)))
    END TRY
    BEGIN CATCH
        -- Log error to dbo.DbError table
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during retrieve operation.', 16, 50000);
    END CATCH
END;
GO
