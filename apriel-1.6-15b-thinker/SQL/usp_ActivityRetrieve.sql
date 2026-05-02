/*=============================================================
  Procedure: dbo.usp_ActivityRetrieve
  Purpose : Return all Activity rows that match the supplied criteria.
            Wild‑card search on string columns, date range filter for dates,
            default values for ActiveFlag and SystemDeleteFlag.
=============================================================*/
CREATE PROCEDURE dbo.usp_ActivityRetrieve
    @ActivityId        [uniqueidentifier] = NULL,
    @ProjectId         [uniqueidentifier] = NULL,
    @ProjectMemberId   [uniqueidentifier] = NULL,
    @Name              [nvarchar](128) = NULL,
    @Description       [nvarchar](4000) = NULL,
    @Tags              [nvarchar](200) = NULL,
    @StartDate         [date] = NULL,
    @TargetDate        [date] = NULL,
    @EndDate           [date] = NULL,
    @ProgressStatus    [tinyint] = NULL,
    @ActivityPoints    [smallint] = NULL,
    @Priority          [tinyint] = NULL,
    @Risk              [tinyint] = NULL,
    @ActiveFlag        [tinyint] = 1,   -- default
    @SystemDeleteFlag  [char](1) = 'N',-- default
    @CreatedDateTime   [datetime2](7) = NULL,
    @SystemTimestamp   [timestamp] = NULL
AS
BEGIN
    SET NOCOUNT ON;

    /*------------------- Input validation -------------------*/
    IF @ActiveFlag IS NOT NULL AND (@ActiveFlag NOT IN (0,1))
                                            THEN THROW 50003, 'ActiveFlag must be 0 or 1.', 1;
    IF @SystemDeleteFlag IS NOT NULL
            AND @SystemDeleteFlag NOT IN ('N','Y')
                                            THEN THROW 50003, 'SystemDeleteFlag must be ''N'' or ''Y''.', 1;

    /* String length checks (only for non‑null inputs) */
    IF @Name IS NOT NULL AND LEN(@Name) > 128
                                                THEN THROW 50002, 'Name exceeds maximum length of 128 characters.', 1;
    IF @Description IS NOT NULL AND LEN(@Description) > 4000
                                                THEN THROW 50002, 'Description exceeds maximum length of 4000 characters.', 1;
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
                                                THEN THROW 50002, 'Tags exceeds maximum length of 200 characters.', 1;

    /*------------------- Build dynamic query -------------------*/
    DECLARE @SQL nvarchar(max) = N'SELECT * FROM dbo.Activity WHERE 1=1';

    IF @ActivityId IS NOT NULL
        SET @SQL += N' AND ActivityId = @ActivityId';
    IF @ProjectId IS NOT NULL
        SET @SQL += N' AND ProjectId = @ProjectId';
    IF @ProjectMemberId IS NOT NULL
        SET @SQL += N' AND ProjectMemberId = @ProjectMemberId';
    IF @Name IS NOT NULL
        SET @SQL += N' AND CHARINDEX(@Name, Name) > 0';
    IF @Description IS NOT NULL
        SET @SQL += N' AND CHARINDEX(@Description, Description) > 0';
    IF @Tags IS NOT NULL
        SET @SQL += N' AND CHARINDEX(@Tags, Tags) > 0';
    IF @StartDate IS NOT NULL
        SET @SQL += N' AND StartDate >= @StartDate AND StartDate < DATEADD(day,1,@StartDate)';
    IF @TargetDate IS NOT NULL
        SET @SQL += N' AND TargetDate >= @TargetDate AND TargetDate < DATEADD(day,1,@TargetDate)';
    IF @EndDate IS NOT NULL
        SET @SQL += N' AND EndDate >= @EndDate AND EndDate < DATEADD(day,1,@EndDate)';
    IF @ProgressStatus IS NOT NULL
        SET @SQL += N' AND ProgressStatus = @ProgressStatus';
    IF @ActivityPoints IS NOT NULL
        SET @SQL += N' AND ActivityPoints = @ActivityPoints';
    IF @Priority IS NOT NULL
        SET @SQL += N' AND Priority = @Priority';
    IF @Risk IS NOT NULL
        SET @SQL += N' AND Risk = @Risk';
    IF @ActiveFlag IS NOT NULL
        SET @SQL += N' AND ActiveFlag = @ActiveFlag';
    IF @SystemDeleteFlag IS NOT NULL
        SET @SQL += N' AND SystemDeleteFlag = @SystemDeleteFlag';
    IF @CreatedDateTime IS NOT NULL
        SET @SQL += N' AND CreatedDateTime >= @CreatedDateTime AND CreatedDateTime < DATEADD(day,1,@CreatedDateTime)';
    IF @SystemTimestamp IS NOT NULL
        SET @SQL += N' AND SystemTimestamp = @SystemTimestamp';

    /*------------------- Execute with TRY…CATCH -------------------*/
    BEGIN TRY
        EXEC sp_executesql 
            @sql               = @SQL,
            @parameters        = QUERY_PARAMETERS
                ( @ActivityId       UNIQUEIDENTIFIER = NULL,
                  @ProjectId        UNIQUEIDENTIFIER = NULL,
                  @ProjectMemberId  UNIQUEIDENTIFIER = NULL,
                  @Name             NVARCHAR(128)   = NULL,
                  @Description      NVARCHAR(4000)  = NULL,
                  @Tags             NVARCHAR(200)   = NULL,
                  @StartDate        DATE           = NULL,
                  @TargetDate       DATE           = NULL,
                  @EndDate          DATE           = NULL,
                  @ProgressStatus   TINYINT         = NULL,
                  @ActivityPoints   SMALLINT        = NULL,
                  @Priority         TINYINT         = NULL,
                  @Risk             TINYINT         = NULL,
                  @ActiveFlag       TINYINT         = 1,
                  @SystemDeleteFlag CHAR(1)          = 'N',
                  @CreatedDateTime  DATETIME2(7)    = NULL,
                  @SystemTimestamp  TIMESTAMP        = NULL );
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
            'dbo.usp_ActivityRetrieve',
            ERROR_PROCEDURE()
        );

        THROW 50000, N'Error occurred during SELECT operation.', 1;
    END CATCH;
END
GO
