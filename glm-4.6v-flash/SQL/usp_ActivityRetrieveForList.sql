CREATE PROCEDURE usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT ActivityId, Name
        FROM dbo.Activity
        WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y';
        
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorTime)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), SYSDATETIME());
        
        THROW 50000, 'Error occurred during RetrieveForList operation.', 1;
    END CATCH
END
GO