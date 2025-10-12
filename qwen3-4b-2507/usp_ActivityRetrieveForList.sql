-- usp_ActivityRetrieveForList
CREATE PROCEDURE usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
            [ActivityId],
            [Name]
        FROM [dbo].[Activity]
        WHERE 
            [SystemDeleteFlag] = 'N'
            AND [ActiveFlag] = 1;
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage
        )
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
        RETURN;
    END CATCH
END
GO
