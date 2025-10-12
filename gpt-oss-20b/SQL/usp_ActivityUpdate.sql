/*--------------------------------------------------------------------
    usp_ActivityUpdate
    Updates an existing Activity record using optimistic locking.
--------------------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityUpdate
(
    @ActivityId        uniqueidentifier,

    @ProjectId         uniqueidentifier,
    @ProjectMemberId   uniqueidentifier,

    @Name              nvarchar(128),
    @Description       nvarchar(4000),

    @StartDate         date = NULL,
    @TargetDate        date = NULL,
    @EndDate           date = NULL,

    @ProgressStatus    tinyint = NULL,
    @ActivityPoints    smallint = NULL,
    @Priority          tinyint = NULL,
    @Risk              tinyint = NULL,
    @Tags              nvarchar(200) = NULL,

    @ActiveFlag        tinyint,                -- NOT NULL
    @SystemDeleteFlag  char(1),                 -- NOT NULL

    @UpdatedDateTime   datetime2(7) = NULL,
    @UpdatedByUser     nvarchar(100) = NULL,
    @UpdatedByProgram  nvarchar(100) = NULL,

    @SystemTimestamp   timestamp          -- optimistic lock
)
AS
BEGIN
    SET NOCOUNT ON;

    /*-----------------------------
        Parameter validation
    -----------------------------*/
    IF @ActivityId IS NULL                      RAISERROR('Missing ActivityId',50001,1);
    IF @ProjectId IS NULL                       RAISERROR('Missing ProjectId',50001,1);
    IF @ProjectMemberId IS NULL                 RAISERROR('Missing ProjectMemberId',50001,1);

    IF @Name IS NULL                            RAISERROR('Missing Name',50001,1);
    IF LEN(@Name) > 128                        RAISERROR('Name exceeds maximum length of 128 characters.',50002,1);

    IF @Description IS NULL                    RAISERROR('Missing Description',50001,1);
    IF LEN(@Description) > 4000                RAISERROR('Description exceeds maximum length of 4000 characters.',50002,1);

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200   RAISERROR('Tags exceeds maximum length of 200 characters.',50002,1);

    IF @ActiveFlag NOT IN (0,1)                 RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.',50003,1);
    IF @SystemDeleteFlag NOT IN ('N','Y')       RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.',50003,1);

    IF @UpdatedDateTime IS NULL                SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser   IS NULL                SET @UpdatedByUser   = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL               SET @UpdatedByProgram= APP_NAME();

    IF LEN(@UpdatedByUser) > 100                RAISERROR('UpdatedByUser exceeds maximum length of 100 characters.',50002,1);
    IF LEN(@UpdatedByProgram) > 100             RAISERROR('UpdatedByProgram exceeds maximum length of 100 characters.',50002,1);

    /*-----------------------------
        Update operation
    -----------------------------*/
    BEGIN TRY
        UPDATE dbo.Activity
           SET ProjectId         = @ProjectId,
               ProjectMemberId   = @ProjectMemberId,
               [Name]            = @Name,
               [Description]     = @Description,
               StartDate         = @StartDate,
               TargetDate        = @TargetDate,
               EndDate           = @EndDate,
               ProgressStatus    = @ProgressStatus,
               ActivityPoints    = @ActivityPoints,
               Priority          = @Priority,
               Risk              = @Risk,
               Tags              = @Tags,
               ActiveFlag        = @ActiveFlag,
               SystemDeleteFlag  = @SystemDeleteFlag,
               UpdatedDateTime   = @UpdatedDateTime,
               UpdatedByUser     = @UpdatedByUser,
               UpdatedByProgram  = @UpdatedByProgram
         WHERE ActivityId      = @ActivityId
           AND SystemTimestamp = @SystemTimestamp;

        IF @@ROWCOUNT = 0
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.',50004,1);
    END TRY
    BEGIN CATCH
        /* Log error to DbError table */
        INSERT INTO dbo.DbError (
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage
        )
        SELECT 
            ERROR_NUMBER()   AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE()    AS ErrorState,
            ERROR_PROCEDURE()AS ErrorProcedure,
            ERROR_LINE()     AS ErrorLine,
            ERROR_MESSAGE()  AS ErrorMessage;
        THROW;   -- Re‑throw the original error
    END CATCH;
END
GO
