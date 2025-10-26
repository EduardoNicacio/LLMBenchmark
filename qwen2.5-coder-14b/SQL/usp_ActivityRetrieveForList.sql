-- usp_ActivityRetrieveForList

CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    BEGIN TRY
        -- Retrieve ActivityId and Name for active, non-deleted records
        SELECT ActivityId, Name
        FROM [dbo].[Activity]
        WHERE 
            ActiveFlag = 1 AND
            SystemDeleteFlag <> 'Y';

    END TRY
    BEGIN CATCH
        -- Log the error to dbo.DbError table
        INSERT INTO [dbo].[DbError] (
            ErrorMessage,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorNumber
        ) VALUES (
            ERROR_MESSAGE(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_NUMBER()
        );

        -- Raise a generic error message
        RAISERROR('Error 50000: Error occurred during RetrieveForList operation.', 16, 1);
    END CATCH
END;
GO