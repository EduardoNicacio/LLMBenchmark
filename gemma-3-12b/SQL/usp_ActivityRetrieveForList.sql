-- usp_ActivityRetrieveForList
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            ActivityId,
            Name
        FROM [dbo].[Activity]
        WHERE ActiveFlag = 1
          AND SystemDeleteFlag <> 'Y';

    END TRY
    BEGIN CATCH
        -- Log Error
        INSERT INTO dbo.DbError (ErrorTime, ApplicationName, ProcedureName, ErrorMessage)
        VALUES (GETDATE(), 'ActivityRetrieveForList', 'usp_ActivityRetrieveForList', ERROR_MESSAGE());

        -- Raise Error
        RAISERROR (50000, 16, 1, 'Error occurred during ActivityRetrieveForList operation.')
        RETURN;
    END CATCH
END;
GO