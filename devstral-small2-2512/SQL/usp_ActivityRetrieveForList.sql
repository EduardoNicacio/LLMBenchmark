CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    BEGIN TRY
        SELECT
            [ActivityId],
            [Name]
        FROM [dbo].[Activity]
        WHERE
            [ActiveFlag] = 1 AND
            [SystemDeleteFlag] <> 'Y'
        ORDER BY [Name];
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] ([ErrorNumber], [ErrorSeverity], [ErrorState], [ErrorProcedure], [ErrorLine], [ErrorMessage])
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());

        RAISERROR('50000: Error occurred during list retrieve operation.', 16, 1);
    END CATCH
END
GO
