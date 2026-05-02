/*=============================================================
  Procedure: dbo.usp_ActivityInsert
  Purpose : Insert a new row into the Activity table.
  Input   : All columns except UpdatedDateTime, UpdatedByUser,
            UpdatedByProgram and SystemTimestamp.
            CreatedDateTime, CreatedByUser and CreatedByProgram are required.
  Output  : Rows affected (0 or 1)
=============================================================*/
CREATE PROCEDURE dbo.usp_ActivityInsert
    @ActivityId        [uniqueidentifier],
    @ProjectId         [uniqueidentifier],
    @ProjectMemberId   [uniqueidentifier],
    @Name              [nvarchar](128),
    @Description       [nvarchar](4000),
    @StartDate         [date] = NULL,
    @TargetDate        [date] = NULL,
    @EndDate           [date] = NULL,
    @ProgressStatus    [tinyint] = NULL,
    @ActivityPoints    [smallint] = NULL,
    @Priority          [tinyint] = NULL,
    @Risk              [tinyint] = NULL,
    @Tags              [nvarchar](200) = NULL,
    @ActiveFlag        [tinyint],
    @SystemDeleteFlag  [char](1),
    @CreatedDateTime   [datetime2](7),
    @CreatedByUser     [nvarchar](100),
    @CreatedByProgram  [nvarchar](100)
AS
BEGIN
    SET NOCOUNT ON;

    /*------------------- Input validation -------------------*/
    IF @ActivityId IS NULL      THEN THROW 50001, 'ActivityId cannot be null.', 1;
    IF @ProjectId IS NULL       THEN THROW 50001, 'ProjectId cannot be null.', 1;
    IF @ProjectMemberId IS NULL THEN THROW 50001, 'ProjectMemberId cannot be null.', 1;
    IF @Name IS NULL            THEN THROW 50001, 'Name cannot be null.', 1;
    IF @Description IS NULL     THEN THROW 50001, 'Description cannot be null.', 1;
    IF @ActiveFlag IS NULL      THEN THROW 50001, 'ActiveFlag cannot be null.', 1;
    IF LEN(@SystemDeleteFlag) <> 1   THEN THROW 50001, 'SystemDeleteFlag must be a single character (N/Y).', 1;
    IF @CreatedDateTime IS NULL     THEN THROW 50001, 'CreatedDateTime cannot be null.', 1;
    IF @CreatedByUser IS NULL       THEN THROW 50001, 'CreatedByUser cannot be null.', 1;
    IF @CreatedByProgram IS NULL   THEN THROW 50001, 'CreatedByProgram cannot be null.', 1;

    /* String length checks */
    IF LEN(@Name) > 128            THEN THROW 50002, 'Name exceeds maximum length of 128 characters.', 1;
    IF LEN(@Description) > 4000   THEN THROW 50002, 'Description exceeds maximum length of 4000 characters.', 1;
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
                                            THEN THROW 50002, 'Tags exceeds maximum length of 200 characters.', 1;
    IF @CreatedByUser IS NOT NULL AND LEN(@CreatedByUser) > 100
                                                THEN THROW 50002, 'CreatedByUser exceeds maximum length of 100 characters.', 1;
    IF @CreatedByProgram IS NOT NULL AND LEN(@CreatedByProgram) > 100
                                                THEN THROW 50002, 'CreatedByProgram exceeds maximum length of 100 characters.', 1;

    /* Flag validation */
    IF @ActiveFlag NOT IN (0,1)   THEN THROW 50003, 'ActiveFlag must be 0 or 1.', 1;
    IF @SystemDeleteFlag NOT IN ('N','Y')
                                            THEN THROW 50003, 'SystemDeleteFlag must be ''N'' or ''Y''.', 1;

    /*------------------- Insert operation -------------------*/
    BEGIN TRY
        INSERT INTO dbo.Activity (
            ActivityId,
            ProjectId,
            ProjectMemberId,
            Name,
            Description,
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
        DECLARE @ErrMsg   nvarchar(4000) = ERROR_MESSAGE(),
                @ErrNum   int          = ERROR_NUMBER(),
                @ErrSev   int          = ERROR_SEVERITY(),
                @ErrStat  int          = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorId, ErrorMessage, ErrorNumber,
                                 ErrorSeverity, ErrorState,
                                 ProcedureName, ParameterInfo)
        VALUES (
            NEWID(),
            @ErrMsg,
            @ErrNum,
            @ErrSev,
            @ErrStat,
            'dbo.usp_ActivityInsert',
            ERROR_PROCEDURE()
        );

        THROW 50000, N'Error occurred during INSERT operation.', 1;
    END CATCH;
END
GO
