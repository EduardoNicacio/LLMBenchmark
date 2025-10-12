-- Stored Procedure for RetrieveForList Operation
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN TRY
    SELECT ActivityId, Name FROM [dbo].[Activity] WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y';
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE();
    RAISERROR('50001', 16, 1); -- Raise error 50001 for null parameters.
END CATCH;
GO