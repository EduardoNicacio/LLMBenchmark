// C# View Models: UpdateViewModel.cs
/// <summary>
/// View model for the Edit Activity page.
/// </summary>
public class UpdateActivityViewModel
{
    public Guid ActivityId { get; set; }
    public Guid ProjectId { get; set; }
    public Guid ProjectMemberId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime? StartDate { get; set; }
    public DateTime? TargetDate { get; set; }
    public DateTime? EndDate { get; set; }
    public byte? ProgressStatus { get; set; }
    public short? ActivityPoints { get; set; }
    public byte? Priority { get; set; }
    public byte? Risk { get; set; }
    public string? Tags { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsDeleted { get; set; } = false;
    public DateTime? UpdatedDateTime { get; set; }
    public string? UpdatedByUser { get; set; }
    public string? UpdatedByProgram { get; set; }
}
