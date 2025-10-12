CREATE PROCEDURE usp_[Entity]Retrieve
BEGIN TRY
    SELECT * FROM [dbo].[Activity]
    WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y' -- Assuming these columns exist in the table definition
        AND (@Description IS NULL OR CHARINDEX(@Description, Description, 0) > 0)
        AND (@CreatedDateTime IS NULL OR CreatedDateTime >= @CreatedDateTime AND CreatedDateTime < DATEADD(day, 1, @CreatedDateTime));
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
        ERROR_MESSAGE();
END CATCH;
