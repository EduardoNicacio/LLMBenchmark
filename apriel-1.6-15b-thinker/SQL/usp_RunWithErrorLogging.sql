/* --------------------------------------------------------------
   Centralised TRY...CATCH helper – can be used inside any proc.
-------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE dbo.RunWithErrorLogging
    @OperationName sysname   -- e.g. 'INSERT', 'UPDATE', 'SELECT'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        /* Insert your INSERT/UPDATE/SELECT statements here.
           They must be placed after the CALL to this procedure. */
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
        RAISERROR('50000',16,1,'Error occurred during %s operation.', @OperationName);
    END CATCH;
END; /* dbo.RunWithErrorLogging */
GO
