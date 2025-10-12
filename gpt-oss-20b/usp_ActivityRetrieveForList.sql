/*--------------------------------------------------------------------
    usp_ActivityRetrieveForList
    Returns a list of ActivityId and Name for active, non‑deleted records.
--------------------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT  ActivityId,
                [Name]
          FROM dbo.Activity
         WHERE SystemDeleteFlag <> 'Y'
           AND ActiveFlag = 1;
    END TRY
    BEGIN CATCH
        /* Log error to DbError table */
        INSERT INTO dbo.DbError (
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage
        )
        SELECT 
            ERROR_NUMBER()   AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE()    AS ErrorState,
            ERROR_PROCEDURE()AS ErrorProcedure,
            ERROR_LINE()     AS ErrorLine,
            ERROR_MESSAGE()  AS ErrorMessage;
        THROW;   -- Re‑throw the original error
    END CATCH;
END
GO
