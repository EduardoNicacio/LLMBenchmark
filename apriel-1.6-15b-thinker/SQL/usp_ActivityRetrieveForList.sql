/*=============================================================
  Procedure: dbo.usp_ActivityRetrieveForList
  Purpose : Return a lightweight list of active, non‑deleted activities.
            Columns returned: ActivityId and Name.
=============================================================*/
CREATE PROCEDURE dbo.usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT ActivityId,
               Name
        FROM dbo.Activity
        WHERE ActiveFlag = 1
          AND SystemDeleteFlag <> 'Y';
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
            'dbo.usp_ActivityRetrieveForList',
            ERROR_PROCEDURE()
        );

        THROW 50000, N'Error occurred during LIST operation.', 1;
    END CATCH;
END
GO
