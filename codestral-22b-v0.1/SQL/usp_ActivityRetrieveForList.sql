-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieveForList]
-- Purpose   : Retrieves a list of active activities from the Activity table, ordered by Name
-- Author    : Eduardo Nicacio
-- Created   : 2023-04-19
-- ============================================================
CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ActivityId, Name
    FROM [dbo].[Activity] WITH (NOLOCK)
    WHERE ActiveFlag = 1 AND SystemDeleteFlag <> 'Y'
    ORDER BY Name ASC;
END;
