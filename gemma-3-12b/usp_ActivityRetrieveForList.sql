CREATE PROCEDURE dbo.usp_ActivityRetrieveForList
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ActivityId,
        Name
    FROM [dbo].[Activity]
    WHERE
        ActiveFlag = 1 AND SystemDeleteFlag <> 'Y';
END;
GO