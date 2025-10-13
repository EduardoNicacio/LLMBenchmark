// src/Dtos/UpdateActivityDto.cs
using System.ComponentModel.DataAnnotations;

namespace MyApp.Data.Dtos;

public class UpdateActivityDto
{
    [Required]
    public Guid ActivityId { get; set; }

    public string ProjectId { get; set; } = null!;

    public string ProjectMemberId { get; set; } = null!;

    public string Name { get; set; }

    public string Description { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? TargetDate { get; set; }

    public short? ProgressStatus { get; set; }

    public short? ActivityPoints { get; set; }

    public short? Priority { get; set; }

    public short? Risk { get; set; }

    [AllowNull]
    public string Tags { get; set; } = null!;

    [Range(0, 1)]
    public short? ActiveFlag { get; set; }
}
