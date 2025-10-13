-- Error logging procedure
CREATE PROCEDURE dbo.LogError
(
    @ErrorMessage NVARCHAR(4000),
    @ErrorSeverity INT,
    @ErrorState INT,
    @ProcedureName NVARCHAR(128)
)
AS
BEGIN
    INSERT INTO dbo.DbError (ErrorMessage, ErrorSeverity, ErrorState, ProcedureName, ErrorTime)
    VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState, @ProcedureName, SYSUTCDATETIME());
END
GO