CREATE PROCEDURE usp_[Entity]Update
    @ActivityId uniqueidentifier,
    -- Assuming all other parameters are input and should include UpdatedDateTime, UpdatedByUser, UpdatedByProgram with similar defaults as Insert procedure.
BEGIN TRY
    UPDATE [dbo].[Activity]
    SET 
        Name = ISNULL(@Name, Name),
        Description = ISNULL(@Description, Description),
        StartDate = ISNULL(@StartDate, StartDate),
        TargetDate = ISNULL(@TargetDate, TargetDate),
        EndDate = ISNULL(@EndDate, EndDate),
        ProgressStatus = ISNULL(@ProgressStatus, ProgressStatus),
        ActivityPoints = ISNULL(@ActivityPoints, ActivityPoints),
        Priority = ISNULL(@Priority, Priority),
        Risk = ISNULL(@Risk, Risk),
        Tags = ISNULL(@Tags, Tags),
        ActiveFlag = ISNULL(@ActiveFlag, ActiveFlag), -- Assuming it can be updated
        UpdatedDateTime = GETUTCDATE(),
        UpdatedByUser = SYSTEM_USER,
        UpdatedByProgram = APP_NAME()
    WHERE ActivityId = @ActivityId AND SystemTimestamp = timestamp; -- Optimistic lock verification
END TRY
BEGIN CATCH
    INSERT INTO [dbo].[DbError] (
        ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage
    )
    SELECT 
        ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
        ERROR_MESSAGE();
END CATCH;
