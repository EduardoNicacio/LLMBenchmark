// C# DTOs: CreateDto.cs
/// <summary>
/// Data Transfer Object for creating a new Activity.
/// </summary>
public class CreateActivityDto
{
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
    public byte ActiveFlag { get; set; } = 1;
    public char SystemDeleteFlag { get; set; } = 'N';
    public string CreatedByUser { get; set; } = string.Empty;
    public string CreatedByProgram { get; set; } = string.Empty;
}
