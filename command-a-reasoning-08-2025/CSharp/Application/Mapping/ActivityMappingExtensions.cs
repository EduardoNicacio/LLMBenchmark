namespace YourApp.Application.Mapping;

public static class ActivityMappingExtensions
{
    public static ActivityReadDto ToReadDto(this Activity entity) =>
        new(
            entity.ActivityId,
            entity.ProjectId,
            entity.ProjectMemberId,
            entity.Name,
            entity.Description,
            entity.StartDate,
            entity.TargetDate,
            entity.EndDate,
            entity.ProgressStatus,
            entity.ActivityPoints,
            entity.Priority,
            entity.Risk,
            entity.Tags,
            entity.ActiveFlag,
            entity.SystemDeleteFlag,
            entity.CreatedDateTime,
            entity.CreatedByUser,
            entity.CreatedByProgram,
            entity.UpdatedDateTime,
            entity.UpdatedByUser,
            entity.UpdatedByProgram
        );

    public static Activity ToEntity(this ActivityCreateDto dto) =>
        new(
            ActivityId: Guid.NewGuid(),
            ProjectId: dto.ProjectId,
            ProjectMemberId: dto.ProjectMemberId,
            Name: dto.Name,
            Description: dto.Description,
            StartDate: dto.StartDate,
            TargetDate: dto.TargetDate,
            EndDate: dto.EndDate,
            ProgressStatus: dto.ProgressStatus,
            ActivityPoints: dto.ActivityPoints,
            Priority: dto.Priority,
            Risk: dto.Risk,
            Tags: dto.Tags,
            ActiveFlag: dto.ActiveFlag,
            SystemDeleteFlag: "N",
            CreatedDateTime: DateTime.UtcNow,
            CreatedByUser: "system", // Replace with actual user in middleware
            CreatedByProgram: "API",
            UpdatedDateTime: null,
            UpdatedByUser: null,
            UpdatedByProgram: null,
            SystemTimestamp: new byte[8]
        );

    public static void UpdateEntity(this ActivityUpdateDto dto, Activity entity)
    {
        entity.Name = dto.Name;
        entity.Description = dto.Description;
        entity.StartDate = dto.StartDate;
        entity.TargetDate = dto.TargetDate;
        entity.EndDate = dto.EndDate;
        entity.ProgressStatus = dto.ProgressStatus;
        entity.ActivityPoints = dto.ActivityPoints;
        entity.Priority = dto.Priority;
        entity.Risk = dto.Risk;
        entity.Tags = dto.Tags;
        entity.ActiveFlag = dto.ActiveFlag;
        entity.UpdatedDateTime = DateTime.UtcNow;
        entity.UpdatedByUser = "system"; // Replace with actual user
        entity.UpdatedByProgram = "API";
    }
}
