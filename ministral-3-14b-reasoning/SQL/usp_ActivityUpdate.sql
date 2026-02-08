CREATE OR ALTER PROCEDURE [dbo].[usp_ActivityUpdate]
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
    @ActiveFlag tinyint = NULL,
    @SystemDeleteFlag char(1) = NULL,
    @UpdatedDateTime datetime2(7) = NULL,
    @UpdatedByUser nvarchar(100) = NULL,
    @UpdatedByProgram nvarchar(100) = NULL,
    @SystemTimestamp binary(8) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate ActivityId is not null (it's the key)
        IF @ActivityId IS NULL
            RAISERROR('ActivityId cannot be null', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50001;

        -- Validate other NOT NULL parameters if provided
        -- ProjectId and ProjectMemberId are NOT NULL in the table
        IF @ProjectId IS NULL OR @ProjectMemberId IS NULL
            RAISERROR('ProjectId and ProjectMemberId cannot be null', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50001;

        -- Validate string lengths for provided parameters
        IF LEN(ISNULL(@Name, '')) > 128
            RAISERROR('Name exceeds maximum length of 128 characters', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50002;

        IF LEN(ISNULL(@Description, '')) > 4000
            RAISERROR('Description exceeds maximum length of 4000 characters', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50002;

        IF LEN(ISNULL(@Tags, '')) > 200
            RAISERROR('Tags exceed maximum length of 200 characters', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50002;

        -- Validate ActiveFlag if provided (it's NOT NULL in table)
        IF @ActiveFlag IS NULL
            RAISERROR('ActiveFlag cannot be null for update', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50001;

        IF @ActiveFlag NOT IN (0, 1)
            RAISERROR('ActiveFlag must be 0 or 1', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50003;

        -- Validate SystemDeleteFlag if provided
        IF @SystemDeleteFlag IS NOT NULL AND @SystemDeleteFlag NOT IN ('N', 'Y')
            RAISERROR('SystemDeleteFlag must be either "N" or "Y"', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50003;

        -- Set default values for updated fields if parameters are null
        DECLARE @CurrentDateTime datetime2(7) = ISNULL(@UpdatedDateTime, SYSUTCDATETIME());
        DECLARE @CurrentUser nvarchar(100) = ISNULL(@UpdatedByUser, SYSTEM_USER);
        DECLARE @CurrentProgram nvarchar(100) = ISNULL(@UpdatedByProgram, APP_NAME());

        -- Check if the record exists and is not deleted
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Activity] WHERE ActivityId = @ActivityId AND SystemDeleteFlag = 'N')
            RAISERROR('Activity with the specified ID does not exist or is already deleted', 16, 1) WITH RAISEDBYCALLER = TRUE;

        -- Update the record with optimistic locking check
        UPDATE [dbo].[Activity]
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
            SystemDeleteFlag = ISNULL(@SystemDeleteFlag, SystemDeleteFlag), -- Only update if provided
            UpdatedDateTime = @CurrentDateTime,
            UpdatedByUser = @CurrentUser,
            UpdatedByProgram = @CurrentProgram
        WHERE
            ActivityId = @ActivityId AND
            (ISNULL(@SystemTimestamp, 0x) = 0x OR SystemTimestamp = @SystemTimestamp) AND -- Handle NULL timestamp case
            SystemDeleteFlag = 'N';

        -- Check if any rows were actually updated (for optimistic locking)
        IF @@ROWCOUNT = 0
            RAISERROR('Operation failed because another user has updated or deleted this Activity. Your changes have been lost. Please review their changes before trying again.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50004;

        -- Return success
        SELECT 1 AS Result;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        INSERT INTO [dbo].[DbError] (
            ErrorNumber, ErrorSeverity, ErrorState,
            ErrorProcedure, ErrorLine,
            ErrorMessage, CreatedDateTime
        )
        VALUES (
            ERROR_NUMBER(), @ErrorSeverity, @ErrorState,
            'usp_ActivityUpdate', ERROR_LINE(),
            @ErrorMessage, SYSUTCDATETIME()
        );

        -- Re-throw the error with our standard message
        RAISERROR('Error occurred during update operation.', 16, 1) WITH RAISEDBYCALLER = TRUE AND ERROR_NUMBER = 50000;
    END CATCH
END;
GO
