CREATE PROCEDURE usp_[Entity]RetrieveForList
BEGIN TRY
    SELECT ActivityId, Name FROM [dbo].[Activity]
    WHERE SystemDeleteFlag <> 'Y' AND ActiveFlag = 1; -- Assuming these columns exist in the table definition
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
        ERROR_MESSAGE();
END CATCH;
