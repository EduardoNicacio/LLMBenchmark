CREATE PROCEDURE usp_ActivityRetrieve
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(128) = NULL,
    @Description NVARCHAR(4000) = NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1, -- Default to active
    @SystemDeleteFlag CHAR(1) = 'N' -- Default to not deleted
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM sysobjects WHERE name='usp_ActivityRetrieve' AND xtype='PC')
        EXEC('DROP PROCEDURE usp_ActivityRetrieve');

    CREATE PROC usp_ActivityRetrieve AS

    BEGIN TRY
        SELECT *
        FROM [dbo].[Activity]
        WHERE ((@ActivityId IS NULL OR ActivityId = @ActivityId)
                AND (@ProjectId IS NULL OR ProjectId = @ProjectId)
                AND (@ProjectMemberId IS NULL OR ProjectMemberId = @ProjectMemberId)
                AND (@Name IS NULL OR Name LIKE '%' + @Name + '%')
                AND (@Description IS NULL OR Description LIKE '%' + @Description + '%')
                AND (@StartDate IS NULL OR StartDate >= @StartDate AND StartDate < DATEADD(day, 1, @StartDate))
                AND (@TargetDate IS NULL OR TargetDate >= @TargetDate AND TargetDate < DATEADD(day, 1, @TargetDate))
                AND (@EndDate IS NULL OR EndDate >= @EndDate AND EndDate < DATEADD(day, 1, @EndDate))
                AND (@ProgressStatus IS NULL OR ProgressStatus = @ProgressStatus)
                AND (@ActivityPoints IS NULL OR ActivityPoints = @ActivityPoints)
                AND (@Priority IS NULL OR Priority = @Priority)
                AND (@Risk IS NULL OR Risk = @Risk)
                AND (@Tags IS NULL OR Tags LIKE '%' + @Tags + '%')
                AND (@ActiveFlag IS NULL OR ActiveFlag = @ActiveFlag)
                AND (@SystemDeleteFlag IS NULL OR SystemDeleteFlag = @SystemDeleteFlag));

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
            @subject = 'Error in usp_ActivityRetrieve',
            @body = 'An error occurred: ' + @ErrorMessage;

        RAISERROR('Error occurred during retrieve operation.', 16, 1);
    END CATCH;
END;
GO
