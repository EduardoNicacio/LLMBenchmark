-- usp_ActivityRetrieve

CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
    @ActivityId uniqueidentifier = NULL,
    @ProjectId uniqueidentifier = NULL,
    @ProjectMemberId uniqueidentifier = NULL,
    @Name nvarchar(128) = NULL,
    @Description nvarchar(4000) = NULL,
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = 1,
    @SystemDeleteFlag char(1) = 'N'
AS
BEGIN
    BEGIN TRY
        -- Validate input parameters
        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200
            RAISERROR('Error 50002: String parameter exceeds column length.', 16, 1);

        IF @ActiveFlag NOT IN (0, 1)
            RAISERROR('Error 50003: Invalid ActiveFlag value. Must be 0 or 1.', 16, 1);

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('Error 50003: Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 1);

        -- Retrieve the activity
        SELECT *
        FROM [dbo].[Activity]
        WHERE 
            (@ActivityId IS NULL OR ActivityId = @ActivityId) AND
            (@ProjectId IS NULL OR ProjectId = @ProjectId) AND
            (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId) AND
            (@Name IS NULL OR CHARINDEX(@Name, Name, 0) > 0) AND
            (@Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0) AND
            (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate)) AND
            (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate)) AND
            (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate)) AND
            (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus) AND
            (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints) AND
            (@Priority IS NULL OR Priority = @Priority) AND
            (@Risk IS NULL OR Risk = @Risk) AND
            (@Tags IS NULL OR CHARINDEX(@Tags, Tags, 0) > 0) AND
            ActiveFlag = @ActiveFlag AND
            SystemDeleteFlag = @SystemDeleteFlag;

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
        RAISERROR('Error 50000: Error occurred during Retrieve operation.', 16, 1);
    END CATCH
END;
GO