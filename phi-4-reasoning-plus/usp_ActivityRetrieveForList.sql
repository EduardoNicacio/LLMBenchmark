CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
-------------------------------------------------------------------
-- Retrieve only ActivityId and Name for non-deleted (SystemDeleteFlag <> 'Y')
-- and active (ActiveFlag = 1) records.
SELECT ActivityId, Name
FROM dbo.Activity
WHERE SystemDeleteFlag <> 'Y' AND ActiveFlag = 1;
END TRY
BEGIN CATCH
-------------------------------------------------------------------
-- Log the error in dbo.DbError.
INSERT INTO [dbo].[DbError]
(
ErrorNumber,
ErrorSeverity,
ErrorState,
ErrorProcedure,
ErrorLine,
ErrorMessage
)
SELECT
ERROR_NUMBER() AS ErrorNumber,
ERROR_SEVERITY() AS ErrorSeverity,
ERROR_STATE() AS ErrorState,
ERROR_PROCEDURE() AS ErrorProcedure,
ERROR_LINE() AS ErrorLine,
ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO