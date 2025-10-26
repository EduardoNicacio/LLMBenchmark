-- usp_ActivityRetrieveForList
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT ActivityId, Name FROM (
            SELECT
                ActivityId,
                Name,
                ROW_NUMBER() OVER (ORDER BY CreatedDateTime DESC) AS RowNumber
            FROM [dbo].[Activity]
            WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y'
        ) AS Subquery
        WHERE RowNumber <= 100;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = 'Error occurred during Retrieve operation.';
        INSERT INTO [dbo].[DbError] (ErrorMessage, ErrorDate) VALUES (@ErrorMessage, SYSUTCDATETIME());

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        RAISERROR(@ErrorMessage, 16, 1);

    END CATCH;
END;
GO