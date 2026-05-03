namespace YourApp.Application.DTOs;

public sealed record ActivityUpdateDto
{
    [Required]
    public Guid ActivityId { get; init; }

    [Required]
    public byte[] SystemTimestamp { get; init; } = null!;

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
