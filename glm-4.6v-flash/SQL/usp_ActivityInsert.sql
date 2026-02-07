CREATE PROCEDURE usp_ActivityInsert
    @ActivityId uniqueidentifier,
    @ProjectId uniqueidentifier,
    @ProjectMemberId uniqueidentifier,
    @Name nvarchar(128),
    @Description nvarchar(4000),
    @StartDate date = NULL,
    @TargetDate date = NULL,
    @EndDate date = NULL,
    @ProgressStatus tinyint = NULL,
    @ActivityPoints smallint = NULL,
    @Priority tinyint = NULL,
    @Risk tinyint = NULL,
    @Tags nvarchar(200) = NULL,
    @ActiveFlag tinyint = 1, -- Default to 1
    @SystemDeleteFlag char(1) = 'N', -- Default to 'N'
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Parameter validation
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR @Name IS NULL OR @Description IS NULL OR @CreatedDateTime IS NULL OR @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
            THROW 50001, 'Null parameter detected.', 1;
            
        -- String length validation
        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR LEN(@CreatedByUser) > 100 OR LEN(@CreatedByProgram) > 100
            THROW 50002, 'String parameter exceeds column length.', 1;
            
        -- ActiveFlag and SystemDeleteFlag validation
        IF @ActiveFlag NOT IN (0, 1)
            THROW 50003, 'Invalid ActiveFlag value. Must be 0 or 1.', 1;
        IF @SystemDeleteFlag NOT IN ('N', 'Y')
            THROW 50003, 'Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 1;
            
        -- Insert data
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
        INSERT INTO dbo.DbError (ErrorNumber, ErrorMessage, ErrorTime)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), SYSDATETIME());
        THROW 50000, 'Error occurred during Insert operation.', 1;
    END CATCH
END
GO