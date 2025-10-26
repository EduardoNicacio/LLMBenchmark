-- usp_ActivityRetrieveForList
CREATE PROCEDURE usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
            [ActivityId],
            [Name]
        FROM [dbo].[Activity]
        WHERE 
            [ActiveFlag] = 1 
            AND [SystemDeleteFlag] <> 'Y';

        RETURN 0;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorMessage, Operation, ErrorNumber, ErrorSeverity, ErrorState, ErrorLine, ErrorProcedure)
        VALUES (ERROR_MESSAGE(), 'RETRIEVEFORLIST', ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

        RAISERROR('50000', 16, 1, 'Error occurred during RETRIEVEFORLIST operation.');
        RETURN -1;
    END CATCH
END
GO
