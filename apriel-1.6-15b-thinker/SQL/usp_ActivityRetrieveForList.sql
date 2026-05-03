-- ============================================================
-- Procedure : [dbo].[usp_ActivityRetrieveForList]
-- Purpose   : Return ActivityId and Name for list view.
-- Author    : Eduardo Nicacio
-- Created   : 2025-09-05
-- ============================================================
CREATE PROCEDURE [dbo].[usp_ActivityRetrieveForList]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [dbo].[Activity].ActivityId, [dbo].[Activity].Name
    FROM [dbo].[Activity] WITH (NOLOCK)
    WHERE [dbo].[Activity].ActiveFlag = 1
      AND [dbo].[Activity].SystemDeleteFlag <> N'Y'
    ORDER BY [dbo].[Activity].Name ASC;
END
GO
