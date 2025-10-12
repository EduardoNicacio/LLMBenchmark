/*--------------------------------------------------------------------
    usp_ActivityDelete
    Soft‑deletes an Activity record using optimistic locking.
--------------------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityDelete
(
    @ActivityId        uniqueidentifier,

    @UpdatedDateTime   datetime2(7) = NULL,
    @UpdatedByUser     nvarchar(100) = NULL,
    @UpdatedByProgram  nvarchar(100) = NULL,

    @SystemTimestamp   timestamp          -- required for optimistic lock
)
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------
        Parameter validation
    -----------------------------*/
    IF @ActivityId IS NULL                      RAISERROR('Missing ActivityId',50001,1);
    IF @SystemTimestamp IS NULL                 RAISERROR('Missing SystemTimestamp',50001,1);

    /* Default values for the audit columns */
    SET @UpdatedDateTime   = COALESCE(@UpdatedDateTime, SYSUTCDATETIME());
    SET @UpdatedByUser     = COALESCE(@UpdatedByUser, SYSTEM_USER);
    SET @UpdatedByProgram  = COALESCE(@UpdatedByProgram, APP_NAME());

    IF LEN(@UpdatedByUser) > 100                RAISERROR('UpdatedByUser exceeds maximum length of 100 characters.',50002,1);
    IF LEN(@UpdatedByProgram) > 100             RAISERROR('UpdatedByProgram exceeds maximum length of 100 characters.',50002,1);

    /*-----------------------------
        Soft‑delete operation
    -----------------------------*/
    BEGIN TRY
        UPDATE dbo.Activity
           SET SystemDeleteFlag = 'Y',
               UpdatedDateTime   = @UpdatedDateTime,
               UpdatedByUser     = @UpdatedByUser,
               UpdatedByProgram  = @UpdatedByProgram
         WHERE ActivityId      = @ActivityId
           AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.',50004,1);
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
