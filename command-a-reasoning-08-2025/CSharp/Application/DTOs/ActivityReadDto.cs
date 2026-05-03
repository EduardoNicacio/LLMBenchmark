namespace YourApp.Application.DTOs;

public sealed record ActivityReadDto
{
    public Guid ActivityId { get; init; }
    public Guid ProjectId { get; init; }
    public Guid ProjectMemberId { get; init; }
    public string Name { get; init; } = null!;
    public string Description { get; init; } = null!;
    public DateOnly? StartDate { get; init; }
    public DateOnly? TargetDate { get; init; }
    public DateOnly? EndDate { get; init; }
    public byte? ProgressStatus { get; init; }
    public short? ActivityPoints { get; init; }
    public byte? Priority { get; init; }
    public byte? Risk { get; init; }
    public string? Tags { get; init; }
    public byte ActiveFlag { get; init; }
    public string SystemDeleteFlag { get; init; } = null!;
    public DateTime CreatedDateTime { get; init; }
    public string CreatedByUser { get; init; } = null!;
    public string CreatedByProgram { get; init; } = null!;
    public DateTime? UpdatedDateTime { get; init; }
    public string? UpdatedByUser { get; init; }
    public string? UpdatedByProgram { get; init; }

    public ActivityReadDto(
        Guid activityId,
        Guid projectId,
        Guid projectMemberId,
        string name,
        string description,
        DateOnly? startDate,
        DateOnly? targetDate,
        DateOnly? endDate,
        byte? progressStatus,
        short? activityPoints,
        byte? priority,
        byte? risk,
        string? tags,
        byte activeFlag,
        string systemDeleteFlag,
        DateTime createdDateTime,
        string createdByUser,
        string createdByProgram,
        DateTime? updatedDateTime,
        string? updatedByUser,
        string? updatedByProgram)
    {
        ActivityId = activityId;
        ProjectId = projectId;
        ProjectMemberId = projectMemberId;
        Name = name;
        Description = description;
        StartDate = startDate;
        TargetDate = targetDate;
        EndDate = endDate;
        ProgressStatus = progressStatus;
        ActivityPoints = activityPoints;
        Priority = priority;
        Risk = risk;
        Tags = tags;
        ActiveFlag = activeFlag;
        SystemDeleteFlag = systemDeleteFlag;
        CreatedDateTime = createdDateTime;
        CreatedByUser = createdByUser;
        CreatedByProgram = createdByProgram;
        UpdatedDateTime = updatedDateTime;
        UpdatedByUser = updatedByUser;
        UpdatedByProgram = updatedByProgram;
    }
}
