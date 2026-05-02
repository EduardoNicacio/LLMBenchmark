-- usp_ActivityRetrieve
CREATE PROCEDURE [dbo].[usp_ActivityRetrieve]
(
    -- Input parameters: All columns (defaulted to NULL) except UpdatedDateTime, UpdatedByUser, UpdatedByProgram
    @ActivityId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(128) = NULL,
    @Description NVARCHAR(4000) = NULL,
    @StartDate DATE = NULL,
    @TargetDate DATE = NULL,
    @EndDate DATE = NULL,
    @ProgressStatus TINYINT = NULL,
    @ActivityPoints SMALLINT = NULL,
    @Priority TINYINT = NULL,
    @Risk TINYINT = NULL,
    @Tags NVARCHAR(200) = NULL,
    @ActiveFlag TINYINT = 1, -- Default to 1
    @SystemDeleteFlag CHAR(1) = 'N', -- Default to 'N'
    -- Excluded: UpdatedDateTime, UpdatedByUser, UpdatedByProgram
    @CreatedDateTime DATETIME2(7) = NULL,
    @CreatedByUser NVARCHAR(100) = NULL,
    @CreatedByProgram NVARCHAR(100) = NULL
)
AS
BEGIN
    -- Validate input parameters
    -- Check nullability for non-nullable columns (if provided as NULL)
    -- IF (@ActivityId IS NULL AND @ActivityId IS NOT NULL) OR -- Non-nullable must not be NULL if provided; but default is NULL so skip check for nullable?
        -- Instead, validate only if parameter is provided and maps to NOT NULL column? But requirement: raise error for null parameters (meaning any input param that is NULL and corresponds to NOT NULL col)
        -- We'll check all non-nullable columns: ActivityId, ProjectId, ... etc. But note: parameters can be NULL for nullable cols.
        -- List non-nullable cols in table: most except the explicitly nullable ones.
        -- To simplify, we check each non-nullable param if it is NULL (but they are defined as =NULL so might be NULL). Requirement says "raise error 50001 for null parameters" - ambiguous.
        -- Interpretation: Raise if a parameter that corresponds to a NOT NULL column in table is NULL.
        -- Since we have defaults for some, but non-nullable must not be NULL. So:
    -- BEGIN
        -- Non-nullable columns in table: ActivityId, ProjectId, ProjectMemberId, Name, Description, ActiveFlag, SystemDeleteFlag, CreatedDateTime, CreatedByUser, CreatedByProgram
        -- But note: parameters for these might be provided as NULL? Then error.
        IF @ActivityId IS NULL OR @ProjectId IS NULL OR @ProjectMemberId IS NULL OR 
           @Name IS NULL OR @Description IS NULL OR @ActiveFlag IS NULL OR 
           @SystemDeleteFlag IS NULL OR @CreatedDateTime IS NULL OR 
           @CreatedByUser IS NULL OR @CreatedByProgram IS NULL
        BEGIN
            RAISERROR('Error 50001: Null parameter detected.', 16, 50001);
            RETURN;
        END
    -- END

    -- Validate string lengths for provided parameters
    IF @Name IS NOT NULL AND LEN(@Name) > 128 BEGIN RAISERROR('Error 50002: Name exceeds column length.', 16, 50002); RETURN; END
    IF @Description IS NOT NULL AND LEN(@Description) > 4000 BEGIN RAISERROR('Error 50002: Description exceeds column length.', 16, 50002); RETURN; END
    IF @Tags IS NOT NULL AND LEN(@Tags) > 200 BEGIN RAISERROR('Error 50002: Tags exceeds column length.', 16, 50002); RETURN; END

    -- Validate ActiveFlag and SystemDeleteFlag values (even if default, but user might override)
    IF @ActiveFlag NOT IN (0, 1) BEGIN RAISERROR('Error 50003: Invalid ActiveFlag value.', 16, 50003); RETURN; END
    IF @SystemDeleteFlag NOT IN ('N', 'Y') BEGIN RAISERROR('Error 50003: Invalid SystemDeleteFlag value.', 16, 50003); RETURN; END

    BEGIN TRY
        SELECT 
            [ActivityId],
            [ProjectId],
            [ProjectMemberId],
            [Name],
            [Description],
            [StartDate],
            [TargetDate],
            [EndDate],
            [ProgressStatus],
            [ActivityPoints],
            [Priority],
            [Risk],
            [Tags],
            [ActiveFlag],
            [SystemDeleteFlag],
            [CreatedDateTime],
            [CreatedByUser],
            [CreatedByProgram],
            [UpdatedDateTime],
            [UpdatedByUser],
            [UpdatedByProgram],
            [SystemTimestamp]
        FROM [dbo].[Activity]
        WHERE 
            -- String column wildcard search
            (@ActivityId IS NULL OR [ActivityId] = @ActivityId) AND
            (@ProjectId IS NULL OR [ProjectId] = @ProjectId) AND
            (@ProjectMemberId IS NULL OR [ProjectMemberId] = @ProjectMemberId) AND
            (@Name IS NULL OR CHARINDEX(@Name, [Name], 0) > 0) AND
            (@Description IS NULL OR CHARINDEX(@Description, [Description], 0) > 0) AND
            (@Tags IS NULL OR CHARINDEX(@Tags, [Tags], 0) > 0) AND
            -- Date column range search
            (@StartDate IS NULL OR [StartDate] >= @StartDate AND [StartDate] < DATEADD(DAY, 1, @StartDate)) AND
            (@TargetDate IS NULL OR [TargetDate] >= @TargetDate AND [TargetDate] < DATEADD(DAY, 1, @TargetDate)) AND
            (@EndDate IS NULL OR [EndDate] >= @EndDate AND [EndDate] < DATEADD(DAY, 1, @EndDate)) AND
            -- ActiveFlag and SystemDeleteFlag defaults applied in WHERE via conditions
            ([ActiveFlag] = @ActiveFlag) AND
            ([SystemDeleteFlag] = @SystemDeleteFlag) AND
            (@CreatedDateTime IS NULL OR [CreatedDateTime] = @CreatedDateTime) AND
            (@CreatedByUser IS NULL OR [CreatedByUser] = @CreatedByUser) AND
            (@CreatedByProgram IS NULL OR [CreatedByProgram] = @CreatedByProgram);
    END TRY
    BEGIN CATCH
        INSERT INTO [dbo].[DbError] (ErrorDateTime, ErrorLevel, ErrorNumber, Message, ConnectionId)
        VALUES (GETDATE(), 1, ERROR_NUMBER(), ERROR_MESSAGE(), @@CONNECTION_ID());
        RAISERROR('Error occurred during Retrieve operation.', 16, 50000);
    END CATCH
END
GO