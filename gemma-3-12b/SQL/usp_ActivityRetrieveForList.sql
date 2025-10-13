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
        WHERE
            ActiveFlag = 1 AND SystemDeleteFlag <> 'Y';

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() <> 0
            INSERT INTO [dbo].[DbError] (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorMessage, ErrorDateTime)
            VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), SYSUTCDATETIME());

        RAISERROR (50000, 16, 1, 'Error occurred during ActivityRetrieveForList operation.');
    END CATCH;
END;
GO