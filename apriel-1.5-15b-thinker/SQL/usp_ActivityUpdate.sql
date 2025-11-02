/*=============================================================
  Procedure: dbo.usp_ActivityUpdate
  Purpose : Update an existing Activity row.
            All columns except the immutable audit fields are exposed.
            UpdatedDateTime/UpdatedByUser/UpdatedByProgram default to current values.
            Optimistic locking is performed via SystemTimestamp.
=============================================================*/
CREATE PROCEDURE dbo.usp_ActivityUpdate
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
    @UpdatedDateTime   [datetime2](7) = NULL,
    @UpdatedByUser     [nvarchar](100) = NULL,
    @UpdatedByProgram  [nvarchar](100) = NULL,
    @SystemTimestamp   [timestamp]
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

    /* String length checks */
    IF LEN(@Name) > 128            THEN THROW 50002, 'Name exceeds maximum length of 128 characters.', 1;
    IF LEN(@Description) > 4000   THEN THROW 50002, 'Description exceeds maximum length of 4000 characters.', 1;
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
                                            THEN THROW 50002, 'Tags exceeds maximum length of 200 characters.', 1;

    /* Flag validation */
    IF @ActiveFlag NOT IN (0,1)   THEN THROW 50003, 'ActiveFlag must be 0 or 1.', 1;
    IF @SystemDeleteFlag NOT IN ('N','Y')
                                            THEN THROW 50003, 'SystemDeleteFlag must be ''N'' or ''Y''.', 1;

    /* Default audit columns */
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser   IS NULL SET @UpdatedByUser   = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    /*------------------- Update operation -------------------*/
    BEGIN TRY
        UPDATE dbo.Activity
        SET
            ProjectId         = @ProjectId,
            ProjectMemberId   = @ProjectMemberId,
            Name              = @Name,
            Description       = @Description,
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
            'dbo.usp_ActivityUpdate',
            ERROR_PROCEDURE()
        );

        IF @ErrNum = 2627   -- optimistic‑lock violation
        BEGIN
            THROW 50004, N'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 1;
        END
        ELSE
        BEGIN
            THROW 50000, N'Error occurred during UPDATE operation.', 1;
        END
    END CATCH;
END
GO
