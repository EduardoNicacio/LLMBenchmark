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
    END TRY
    BEGIN CATCH
        -- Log error
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorTime)
        VALUES (
            ERROR_NUMBER(),
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            GETUTCDATE()
        );

        -- Raise error
        RAISERROR('Error 50000: Error occurred during ActivityRetrieveForList operation.', 16, 1);
    END CATCH
END;
GO
