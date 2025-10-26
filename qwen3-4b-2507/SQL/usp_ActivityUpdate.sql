-- usp_ActivityUpdate
CREATE PROCEDURE usp_ActivityUpdate
    @ActivityId UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER,
    @ProjectMemberId UNIQUEIDENTIFIER,
    @Name NVARCHAR(128),
    @Description NVARCHAR(4000),
    @StartDate DATE,
    @TargetDate DATE,
    @EndDate DATE,
    @ProgressStatus TINYINT,
    @ActivityPoints SMALLINT,
    @Priority TINYINT,
    @Risk TINYINT,
    @Tags NVARCHAR(200),
    @ActiveFlag TINYINT,
    @SystemDeleteFlag CHAR(1),
    @UpdatedDateTime DATETIME2(7),
    @UpdatedByUser NVARCHAR(100),
    @UpdatedByProgram NVARCHAR(100),
    @SystemTimestamp TIMESTAMP
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
    IF @ActivityId IS NULL
    BEGIN
        RAISERROR('50001', 16, 1, 'Null parameter detected in usp_ActivityUpdate');
        RETURN;
    END

    IF @Name IS NOT NULL AND LEN(@Name) > 128
    BEGIN
        RAISERROR('50002', 16, 1, 'Name exceeds maximum length of 128 characters');
        RETURN;
    END

    IF @Description IS NOT NULL AND LEN(@Description) > 4000
    BEGIN
        RAISERROR('50002', 16, 1, 'Description exceeds maximum length of 4000 characters');
        RETURN;
    END

    IF @Tags IS NOT NULL AND LEN(@Tags) > 200
    BEGIN
        RAISERROR('50002', 16, 1, 'Tags exceeds maximum length of 200 characters');
        RETURN;
    END

    IF @ActiveFlag NOT IN (0, 1)
    BEGIN
        RAISERROR('50003', 16, 1, 'Invalid ActiveFlag value. Must be 0 or 1.');
        RETURN;
    END

    IF @SystemDeleteFlag NOT IN ('N', 'Y')
    BEGIN
        RAISERROR('50003', 16, 1, 'Invalid SystemDeleteFlag value. Must be ''N'' or ''Y''.');
        RETURN;
    END

    -- Default values for optional parameters
    IF @UpdatedDateTime IS NULL
        SET @UpdatedDateTime = SYSUTCDATETIME();
    IF @UpdatedByUser IS NULL
        SET @UpdatedByUser = SYSTEM_USER;
    IF @UpdatedByProgram IS NULL
        SET @UpdatedByProgram = APP_NAME();

    BEGIN TRY
        UPDATE [dbo].[Activity]
        SET 
            [ProjectId] = @ProjectId,
            [ProjectMemberId] = @ProjectMemberId,
            [Name] = @Name,
            [Description] = @Description,
            [StartDate] = @StartDate,
            [TargetDate] = @TargetDate,
            [EndDate] = @EndDate,
            [ProgressStatus] = @ProgressStatus,
            [ActivityPoints] = @ActivityPoints,
            [Priority] = @Priority,
            [Risk] = @Risk,
            [Tags] = @Tags,
            [ActiveFlag] = @ActiveFlag,
            [SystemDeleteFlag] = @SystemDeleteFlag,
            [UpdatedDateTime] = @UpdatedDateTime,
            [UpdatedByUser] = @UpdatedByUser,
            [UpdatedByProgram] = @UpdatedByProgram
        WHERE 
            [ActivityId] = @ActivityId
            AND [SystemTimestamp] = @SystemTimestamp
            AND [SystemDeleteFlag] = 'N';

        RETURN 0;
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.DbError (ErrorMessage, Operation, ErrorNumber, ErrorSeverity, ErrorState, ErrorLine, ErrorProcedure)
        VALUES (ERROR_MESSAGE(), 'UPDATE', ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

        IF ERROR_NUMBER() = 2627 -- Optimistic lock violation
        BEGIN
            RAISERROR('50004', 16, 1, 'Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.');
        END
        ELSE
        BEGIN
            RAISERROR('50000', 16, 1, 'Error occurred during UPDATE operation.');
        END

        RETURN -1;
    END CATCH
END
GO
