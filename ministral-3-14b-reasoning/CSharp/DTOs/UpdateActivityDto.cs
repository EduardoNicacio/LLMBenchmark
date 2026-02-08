using System;
using System.ComponentModel.DataAnnotations;

public class UpdateActivityDto
{
    [Required]
    public Guid ActivityId { get; set; }

    public Guid ProjectId { get; set; }
    public Guid ProjectMemberId { get; set; }

    [MaxLength(128)]
    public string Name { get; set; }

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

    public bool ActiveFlag { get; set; }
    public bool SystemDeleteFlag { get; set; } // Set to true to soft-delete
}
