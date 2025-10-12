/*****************************************************************************************
*  Procedure: usp_ActivityRetrieveForList
*  Purpose : Return a drop‑down list of all **active** and **non‑deleted**
*            Activity rows. Only the columns needed for the UI are returned.
*****************************************************************************************/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ActivityId,
        Name
    FROM dbo.Activity
    WHERE SystemDeleteFlag <> 'Y'   -- not soft‑deleted
      AND ActiveFlag = 1;           -- active

    /* ------------------- TRY…CATCH wrapper ---------------------------------------- */
    BEGIN TRY
        /* The SELECT statement above is already inside the try block. */
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorNumber, ErrorSeverity, ErrorState,
                                 ErrorProcedure, ErrorLine, ErrorMessage)
        SELECT ERROR_NUMBER()   AS ErrorNumber,
               ERROR_SEVERITY()  AS ErrorSeverity,
               ERROR_STATE()     AS ErrorState,
               ERROR_PROCEDURE()  AS ErrorProcedure,
               ERROR_LINE()      AS ErrorLine,
               ERROR_MESSAGE()   AS ErrorMessage;
        RAISERROR('50000',16,1,'Error occurred during SELECT operation for list.');
    END CATCH;
END; /* usp_ActivityRetrieveForList */
