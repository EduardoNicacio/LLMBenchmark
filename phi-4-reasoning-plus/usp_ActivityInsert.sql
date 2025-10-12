CREATE PROCEDURE [dbo].[usp_ActivityInsert]
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
@ActiveFlag TINYINT NOT NULL, -- must be either 0 or 1
@SystemDeleteFlag CHAR(1) NOT NULL, -- must be 'N' or 'Y'
@CreatedDateTime DATETIME2(7) NOT NULL,
@CreatedByUser NVARCHAR(100) NOT NULL,
@CreatedByProgram NVARCHAR(100) NOT NULL
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
-------------------------------------------------------------------
-- Validate required parameters (they must not be null).
IF @ActivityId IS NULL
OR @ProjectId IS NULL
OR @ProjectMemberId IS NULL
OR @Name IS NULL
OR @Description IS NULL
OR @ActiveFlag IS NULL
OR @SystemDeleteFlag IS NULL
OR @CreatedDateTime IS NULL
OR @CreatedByUser IS NULL
OR @CreatedByProgram IS NULL
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
    IF LEN(@CreatedByUser) > 100
        RAISERROR ('Parameter CreatedByUser length exceeds maximum allowed (100).', 16, 50002);
    IF LEN(@CreatedByProgram) > 100
        RAISERROR ('Parameter CreatedByProgram length exceeds maximum allowed (100).', 16, 50002);

    -------------------------------------------------------------------
    -- Validate flag parameters.
    IF @ActiveFlag NOT IN (0,1)
        RAISERROR ('Parameter ActiveFlag must be either 0 or 1.', 16, 50003);
    IF @SystemDeleteFlag NOT IN ('N','Y')
        RAISERROR ('Parameter SystemDeleteFlag must be ''N'' or ''Y''.', 16, 50003);

    -------------------------------------------------------------------
    -- Insert the new record.
    INSERT INTO dbo.Activity
    (
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
    VALUES
    (
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