CREATE PROCEDURE [dbo].[usp_ActivityUpdate]
(
@ActivityId UNIQUEIDENTIFIER NOT NULL,
@ProjectId UNIQUEIDENTIFIER NOT NULL,
@ProjectMemberId UNIQUEIDENTIFIER NOT NULL,
@Name NVARCHAR(128) NOT NULL,
@Description NVARCHAR(4000) NOT NULL,
@StartDate DATE = NULL,
@TargetDate DATE = NULL,
@EndDate DATE = NULL,
@ProgressStatus TINYINT = NULL,
@ActivityPoints SMALLINT = NULL,
@Priority TINYINT = NULL,
@Risk TINYINT = NULL,
@Tags NVARCHAR(200) = NULL,
@ActiveFlag TINYINT NOT NULL,  -- must be either 0 or 1
@SystemDeleteFlag CHAR(1) NOT NULL,  -- must be 'N' or 'Y'
@UpdatedDateTime DATETIME2(7) = NULL,
@UpdatedByUser NVARCHAR(100) = NULL,
@UpdatedByProgram NVARCHAR(100) = NULL,
@SystemTimestamp VARBINARY(8) NOT NULL
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
-------------------------------------------------------------------
-- Validate required parameters.
IF @ActivityId IS NULL
OR @ProjectId IS NULL
OR @ProjectMemberId IS NULL
OR @Name IS NULL
OR @Description IS NULL
OR @ActiveFlag IS NULL
OR @SystemDeleteFlag IS NULL
OR @SystemTimestamp IS NULL
BEGIN
RAISERROR ('One or more required parameters are null.', 16, 50001);
RETURN;
END
    -------------------------------------------------------------------
    -- Validate lengths for varchar/nvarchar fields.
    IF LEN(@Name) > 128
        RAISERROR ('Parameter Name length exceeds maximum allowed (128).', 16, 50002);
    IF LEN(@Description) > 4000
        RAISERROR ('Parameter Description length exceeds maximum allowed (4000).', 16, 50002);
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
        RAISERROR ('Parameter Tags length exceeds maximum allowed (200).', 16, 50002);

    -------------------------------------------------------------------
    -- Default values for updated columns if they are null.
    IF @UpdatedDateTime IS NULL SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL SET @UpdatedByProgram = APP_NAME();

    -------------------------------------------------------------------
    -- Validate flag parameters.
    IF @ActiveFlag NOT IN (0,1)
        RAISERROR ('Parameter ActiveFlag must be either 0 or 1.', 16, 50003);
    IF @SystemDeleteFlag NOT IN ('N','Y')
        RAISERROR ('Parameter SystemDeleteFlag must be ''N'' or ''Y''.', 16, 50003);

    -------------------------------------------------------------------
    -- Optimistic lock check.
    DECLARE @RowCount INT;
    SELECT @RowCount = COUNT(*) 
    FROM dbo.Activity
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;

    IF (@RowCount = 0)
    BEGIN
        RAISERROR ('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 50004);
        RETURN;
    END

    -------------------------------------------------------------------
    -- Update the record.
    UPDATE dbo.Activity
    SET 
        ProjectId = @ProjectId,
        ProjectMemberId = @ProjectMemberId,
        Name = @Name,
        Description = @Description,
        StartDate = @StartDate,
        TargetDate = @TargetDate,
        EndDate = @EndDate,
        ProgressStatus = @ProgressStatus,
        ActivityPoints = @ActivityPoints,
        Priority = @Priority,
        Risk = @Risk,
        Tags = @Tags,
        ActiveFlag = @ActiveFlag,
        SystemDeleteFlag = @SystemDeleteFlag,
        UpdatedDateTime = @UpdatedDateTime,
        UpdatedByUser = @UpdatedByUser,
        UpdatedByProgram = @UpdatedByProgram
    WHERE ActivityId = @ActivityId AND SystemTimestamp = @SystemTimestamp;
END TRY
BEGIN CATCH
    -------------------------------------------------------------------
    -- Log the error in dbo.DbError.
    INSERT INTO [dbo].[DbError] 
    (
        ErrorNumber,
        ErrorSeverity,
        ErrorState,
        ErrorProcedure,
        ErrorLine,
        ErrorMessage
    )
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH
END
GO