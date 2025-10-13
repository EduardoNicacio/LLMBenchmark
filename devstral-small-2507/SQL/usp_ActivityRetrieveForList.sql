-- usp_ActivityRetrieveForList  
CREATE PROCEDURE dbo.usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            [ActivityId],
            [Name]
        FROM
            [dbo].[Activity] WITH (NOLOCK)
        WHERE
            [ActiveFlag] = 1 AND
            [SystemDeleteFlag] <> 'Y';

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Log error to dbo.DbError table
        INSERT INTO dbo.DbError (ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during ActivityRetrieveForList operation.', 16, 50000);
    END CATCH
END
GO
