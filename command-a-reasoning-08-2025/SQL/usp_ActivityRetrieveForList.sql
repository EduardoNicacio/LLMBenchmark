-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieveForList]
-- Purpose   : Retrieves active Activities for list display
-- Author    : Eduardo Nicacio
-- Created   : 2025-06-15
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
SET NOCOUNT ON;

SELECT 
    [ActivityId], [Name]
FROM [dbo].[Activity] WITH (NOLOCK)
WHERE 
    [ActiveFlag] = 1
    AND [SystemDeleteFlag] <> 'Y'
ORDER BY [Name] ASC;
RETURN;
