using System;
using System.ComponentModel.DataAnnotations;

public class CreateActivityDto
{
    [Required]
    public Guid ProjectId { get; set; }

    [Required]
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

    [DefaultValue(true)] // Active by default
    public bool ActiveFlag { get; set; } = true;

    [DefaultValue(false)] // Not deleted by default
    public bool SystemDeleteFlag { get; set; } = false;
}
