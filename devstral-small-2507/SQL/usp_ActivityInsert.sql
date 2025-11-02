CREATE PROCEDURE [dbo].[usp_ActivityInsert]
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
    @ActiveFlag tinyint,
    @SystemDeleteFlag char(1),
    @CreatedDateTime datetime2(7),
    @CreatedByUser nvarchar(100),
    @CreatedByProgram nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR 
           @Name IS NULL OR @Description IS NULL OR @CreatedDateTime IS NULL OR 
           @CreatedByUser IS NULL OR @CreatedByProgram IS NULL OR @ActiveFlag IS NULL OR @SystemDeleteFlag IS NULL
        BEGIN
            RAISERROR('Required parameter is null.', 16, 50001);
            RETURN;
        END

        IF LEN(@Name) > 128 OR LEN(@Description) > 4000 OR LEN(@Tags) > 200 OR 
           LEN(@CreatedByUser) > 100 OR LEN(@CreatedByProgram) > 100
        BEGIN
            RAISERROR('String parameter exceeds column length.', 16, 50002);
            RETURN;
        END

        IF @ActiveFlag NOT IN (0, 1)
        BEGIN
            RAISERROR('Invalid ActiveFlag value. Must be 0 or 1.', 16, 50003);
            RETURN;
        END

        IF @SystemDeleteFlag NOT IN ('N', 'Y')
        BEGIN
            RAISERROR('Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.', 16, 50003);
            RETURN;
        END

        -- Insert the new activity record
        INSERT INTO [dbo].[Activity] (
            ActivityId, ProjectId, ProjectMemberId, Name, Description,
            StartDate, TargetDate, EndDate, ProgressStatus, ActivityPoints,
            Priority, Risk, Tags, ActiveFlag, SystemDeleteFlag,
            CreatedDateTime, CreatedByUser, CreatedByProgram
        ) VALUES (
            @ActivityId, @ProjectId, @ProjectMemberId, @Name, @Description,
            @StartDate, @TargetDate, @EndDate, @ProgressStatus, @ActivityPoints,
            @Priority, @Risk, @Tags, @ActiveFlag, @SystemDeleteFlag,
            @CreatedDateTime, @CreatedByUser, @CreatedByProgram
        );
    END TRY
    BEGIN CATCH
        -- Log error to dbo.DbError table
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO dbo.DbError (ErrorTime, ErrorMessage, ErrorSeverity, ErrorState)
        VALUES (GETDATE(), @ErrorMessage, @ErrorSeverity, @ErrorState);

        RAISERROR('Error occurred during insert operation.', 16, 50000);
    END CATCH
END;
GO
