using System;
using System.ComponentModel.DataAnnotations;

public enum ProgressStatusEnum : byte
{
    NotStarted = 0,
    InProgress = 1,
    Completed = 2,
    OnHold = 3
}

public enum PriorityEnum : byte
{
    Low = 0,
    Medium = 1,
    High = 2
}

public enum RiskEnum : byte
{
    Low = 0,
    Medium = 1,
    High = 2
}

public class Activity
{
    [Key]
    public Guid ActivityId { get; set; }

    public Guid ProjectId { get; set; }
    public Guid ProjectMemberId { get; set; }

    [Required]
    [MaxLength(128)]
    public string Name { get; set; }

    [Required]
    [MaxLength(4000)]
    public string Description { get; set; }

    public DateOnly? StartDate { get; set; }
    public DateOnly? TargetDate { get; set; }
    public DateOnly? EndDate { get; set; }

    public ProgressStatusEnum? ProgressStatus { get; set; }
    [Range(0, 32767)]
    public short? ActivityPoints { get; set; }
    public PriorityEnum? Priority { get; set; }
    public RiskEnum? Risk { get; set; }

    [MaxLength(200)]
    public string Tags { get; set; }

    // ActiveFlag: 1 = active, 0 = inactive (tinyint in DB)
    public bool ActiveFlag { get; set; } = true;

    // SystemDeleteFlag: 'Y'/'N' in DB, represented as bool where true = deleted
    public bool SystemDeleteFlag { get; set; } = false;

    [Required]
    public DateTime CreatedDateTime { get; set; }

    [Required]
    [MaxLength(100)]
    public string CreatedByUser { get; set; }

    [Required]
    [MaxLength(100)]
    public string CreatedByProgram { get; set; }

    public DateTime? UpdatedDateTime { get; set; }
    [MaxLength(100)]
    public string UpdatedByUser { get; set; }
    [MaxLength(100)]
    public string UpdatedByProgram { get; set; }
}
