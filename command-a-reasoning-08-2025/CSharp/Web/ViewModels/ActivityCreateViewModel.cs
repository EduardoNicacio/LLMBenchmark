namespace YourApp.Web.ViewModels;

public sealed class ActivityCreateViewModel
{
    [Required]
    public Guid ProjectId { get; set; }

    [Required]
    public Guid ProjectMemberId { get; set; }

    [Required]
    [MaxLength(128)]
    public string Name { get; set; } = null!;

    [Required]
    [MaxLength(4000)]
    public string Description { get; set; } = null!;

    public DateOnly? StartDate { get; set; }

    public DateOnly? TargetDate { get; set; }

    public DateOnly? EndDate { get; set; }

    public byte? ProgressStatus { get; set; }

    public short? ActivityPoints { get; set; }

    public byte? Priority { get; set; }

    public byte? Risk { get; set; }

    [MaxLength(200)]
    public string? Tags { get; set; }

    [Required]
    public byte ActiveFlag { get; set; }

    public IEnumerable<SelectListItem>? ProgressStatusOptions { get; set; }
    public IEnumerable<SelectListItem>? PriorityOptions { get; set; }
    public IEnumerable<SelectListItem>? RiskOptions { get; set; }
}
