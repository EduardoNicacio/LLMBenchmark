/*--------------------------------------------------------------------
    usp_ActivityInsert
    Inserts a new Activity record.
--------------------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_ActivityInsert
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

    @CreatedDateTime   datetime2(7),
    @CreatedByUser     nvarchar(100),
    @CreatedByProgram  nvarchar(100)
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
    IF LEN(@Name) > 128                         RAISERROR('Name exceeds maximum length of 128 characters.',50002,1);

    IF @Description IS NULL                     RAISERROR('Missing Description',50001,1);
    IF LEN(@Description) > 4000                 RAISERROR('Description exceeds maximum length of 4000 characters.',50002,1);

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200   RAISERROR('Tags exceeds maximum length of 200 characters.',50002,1);

    IF @ActiveFlag NOT IN (0,1)                 RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.',50003,1);
    IF @SystemDeleteFlag NOT IN ('N','Y')       RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.',50003,1);

    IF @CreatedDateTime IS NULL                 RAISERROR('Missing CreatedDateTime',50001,1);
    IF @CreatedByUser IS NULL                   RAISERROR('Missing CreatedByUser',50001,1);
    IF LEN(@CreatedByUser) > 100                RAISERROR('CreatedByUser exceeds maximum length of 100 characters.',50002,1);

    IF @CreatedByProgram IS NULL                RAISERROR('Missing CreatedByProgram',50001,1);
    IF LEN(@CreatedByProgram) > 100             RAISERROR('CreatedByProgram exceeds maximum length of 100 characters.',50002,1);

    /*-----------------------------
        Insert operation
    -----------------------------*/
    BEGIN TRY
        INSERT INTO dbo.Activity(
                ActivityId,
                ProjectId,
                ProjectMemberId,
                [Name],
                [Description],
                StartDate,
                TargetDate,
                EndDate,
                ProgressStatus,
                ActivityPoints,
                Priority,
                Risk,
                Tags,
                ActiveFlag,
                SystemDeleteFlag,
                CreatedDateTime,
                CreatedByUser,
                CreatedByProgram
            )
        VALUES (
                @ActivityId,
                @ProjectId,
                @ProjectMemberId,
                @Name,
                @Description,
                @StartDate,
                @TargetDate,
                @EndDate,
                @ProgressStatus,
                @ActivityPoints,
                @Priority,
                @Risk,
                @Tags,
                @ActiveFlag,
                @SystemDeleteFlag,
                @CreatedDateTime,
                @CreatedByUser,
                @CreatedByProgram
            );
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
