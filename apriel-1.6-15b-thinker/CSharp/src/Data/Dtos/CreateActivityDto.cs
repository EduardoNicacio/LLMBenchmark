// src/Dtos/CreateActivityDto.cs
using System.ComponentModel.DataAnnotations;

namespace MyApp.Data.Dtos;

public class CreateActivityDto
{
    [Required]
    public string ProjectId { get; set; } = null!;

    [Required]
    public string ProjectMemberId { get; set; } = null!;

    [Required, MaxLength(128)]
    public string Name { get; set; } = null!;

    [Required, MaxLength(4000)]
    public string Description { get; set; } = null!;

    public DateTime? StartDate { get; set; }

    public DateTime? TargetDate { get; set; }

    public short? ProgressStatus { get; set; }

    public short? ActivityPoints { get; set; }

    public short? Priority { get; set; }

    public short? Risk { get; set; }

    [AllowNull]
    public string Tags { get; set; } = null!;

    [Required, Range(0, 1)]
    public short ActiveFlag { get; set; } = 1;

    [Required, ColumnType("char", "1")]
    public char SystemDeleteFlag { get; set; } = 'N';

    // Auditing fields are auto‑filled by the service layer.
}
