/*****************************************************************************************
*  Procedure: usp_ActivityDelete
*  Purpose : Soft‑delete a row (SystemDeleteFlag = 'Y') with optimistic lock.
*****************************************************************************************/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityDelete
(
    @ActivityId        UNIQUEIDENTIFIER,
    @UpdatedDateTime   DATETIME2(7) = NULL,
    @UpdatedByUser     NVARCHAR(100) = NULL,
    @UpdatedByProgram  NVARCHAR(100) = NULL,
    @SystemTimestamp   TIMESTAMP
)
AS
BEGIN
    SET NOCOUNT ON;

    /* ------------------- Validation ------------------------------------------------- */
    IF @ActivityId IS NULL               THEN RAISERROR(50001,'@ActivityId cannot be NULL.',0);
    IF @SystemTimestamp IS NULL          THEN RAISERROR(50001,'@SystemTimestamp cannot be NULL.',0);

    /* Default audit values if they are omitted */
    IF @UpdatedDateTime IS NULL      SET @UpdatedDateTime   = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL        SET @UpdatedByUser     = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL     SET @UpdatedByProgram  = APP_NAME();

    /* ------------------- Optimistic lock check ------------------------------------ */
    SELECT @CurrentTS = SystemTimestamp
    FROM dbo.Activity
    WHERE ActivityId = @ActivityId;

    IF @CurrentTS IS NULL
        THEN RAISERROR(50004,'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.',0);
    ELSE IF @CurrentTS <> @SystemTimestamp
        THEN RAISERROR(50004,'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.',0);

    /* ------------------- Soft‑delete ------------------------------------------------ */
    UPDATE dbo.Activity
    SET SystemDeleteFlag = 'Y',
        UpdatedDateTime   = @UpdatedDateTime,
        UpdatedByUser     = @UpdatedByUser,
        UpdatedByProgram  = @UpdatedByProgram
    WHERE ActivityId = @ActivityId
      AND SystemTimestamp = @SystemTimestamp;

    /* ------------------- TRY…CATCH wrapper ---------------------------------------- */
    BEGIN TRY
        /* The UPDATE statement above is already inside the try block. */
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
        RAISERROR('50000',16,1,'Error occurred during DELETE operation.');
    END CATCH;
END; /* usp_ActivityDelete */
