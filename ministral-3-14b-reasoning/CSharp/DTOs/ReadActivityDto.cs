using System;

public class ReadActivityDto
{
    public Guid ActivityId { get; set; }
    public Guid ProjectId { get; set; }
    public Guid ProjectMemberId { get; set; }

    public string Name { get; set; }
    public string Description { get; set; }

    public DateOnly? StartDate { get; set; }
    public DateOnly? TargetDate { get; set; }
    public DateOnly? EndDate { get; set; }

    public ProgressStatusEnum? ProgressStatus { get; set; }
    public short? ActivityPoints { get; set; }
    public PriorityEnum? Priority { get; set; }
    public RiskEnum? Risk { get; set; }

    public string Tags { get; set; }

    public bool ActiveFlag { get; set; }
    public bool IsDeleted => SystemDeleteFlag;

    public DateTime CreatedDateTime { get; set; }
    public string CreatedByUser { get; set; }
    public string CreatedByProgram { get; set; }

    public DateTime? UpdatedDateTime { get; set; }
    public string UpdatedByUser { get; set; }
    public string UpdatedByProgram { get; set; }
}
