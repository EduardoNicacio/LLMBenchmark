/*=============================================================
  Procedure: dbo.usp_ActivityDelete
  Purpose : Soft‑delete an Activity row by setting SystemDeleteFlag='Y'.
  Input   : ActivityId, SystemTimestamp (optimistic lock), optional audit fields.
            If any of UpdatedDateTime/UpdatedByUser/UpdatedByProgram are NULL,
            they default to SYSUTCDATETIME(), SYSTEM_USER and APP_NAME().
=============================================================*/
CREATE PROCEDURE dbo.usp_ActivityDelete
    @ActivityId        [uniqueidentifier],
    @SystemTimestamp   [timestamp],
    @UpdatedDateTime   [datetime2](7) = NULL,
    @UpdatedByUser     [nvarchar](100) = NULL,
    @UpdatedByProgram  [nvarchar](100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    /*------------------- Input validation -------------------*/
    IF @ActivityId IS NULL       THEN THROW 50001, 'ActivityId cannot be null.', 1;
    IF @SystemTimestamp IS NULL  THEN THROW 50001, 'SystemTimestamp cannot be null.', 1;

    /* Default audit columns */
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser   IS NULL SET @UpdatedByUser   = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    DECLARE @SystemDeleteFlag char(1) = 'Y';

    /*------------------- Delete (soft‑delete) operation -------------------*/
    BEGIN TRY
        UPDATE dbo.Activity
        SET
            SystemDeleteFlag = @SystemDeleteFlag,
            UpdatedDateTime   = @UpdatedDateTime,
            UpdatedByUser     = @UpdatedByUser,
            UpdatedByProgram  = @UpdatedByProgram
        WHERE ActivityId      = @ActivityId
          AND SystemTimestamp = @SystemTimestamp;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg   nvarchar(4000) = ERROR_MESSAGE(),
                @ErrNum   int          = ERROR_NUMBER(),
                @ErrSev   int          = ERROR_SEVERITY(),
                @ErrStat  int          = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorId, ErrorMessage, ErrorNumber,
                                 ErrorSeverity, ErrorState,
                                 ProcedureName, ParameterInfo)
        VALUES (
            NEWID(),
            @ErrMsg,
            @ErrNum,
            @ErrSev,
            @ErrStat,
            'dbo.usp_ActivityDelete',
            ERROR_PROCEDURE()
        );

        IF @ErrNum = 2627   -- optimistic‑lock violation
        BEGIN
            THROW 50004, N'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 1;
        END
        ELSE
        BEGIN
            THROW 50000, N'Error occurred during DELETE operation.', 1;
        END
    END CATCH;
END
GO
