namespace YourApp.Application.DTOs;

public sealed record ActivityCreateDto
{
    [Required]
    public Guid ProjectId { get; init; }

    [Required]
    public Guid ProjectMemberId { get; init; }

    [Required]
    [MaxLength(128)]
    public string Name { get; init; } = null!;

    [Required]
    [MaxLength(4000)]
    public string Description { get; init; } = null!;

    public DateOnly? StartDate { get; init; }

    public DateOnly? TargetDate { get; init; }

    public DateOnly? EndDate { get; init; }

    public byte? ProgressStatus { get; init; }

    public short? ActivityPoints { get; init; }

    public byte? Priority { get; init; }

    public byte? Risk { get; init; }

    [MaxLength(200)]
    public string? Tags { get; init; }

    [Required]
    public byte ActiveFlag { get; init; }
}
