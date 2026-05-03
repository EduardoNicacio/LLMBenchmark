// Activity.cs
using Microsoft.EntityFrameworkCore;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace YourApp.Domain.Entities;

[Table("Activity", Schema = "dbo")]
public sealed class Activity
{
    [Key]
    public Guid ActivityId { get; set; }

    [Required]
    public Guid ProjectId { get; set; }

    [Required]
    public Guid ProjectId { get; set; }

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

    public byte ActiveFlag { get; set; } = 1;

    [Required]
    [MaxLength(1)]
    public string SystemDeleteFlag { get; set; } = "N";

    public DateTime CreatedDateTime { get; set; }

    [Required]
    [MaxLength(100)]
    public string CreatedByUser { get; set; } = null!;

    [Required]
    [MaxLength(100)]
    public string CreatedByProgram { get; set; } = null!;

    public DateTime? UpdatedDateTime { get; set; }

    [MaxLength(100)]
    public string? UpdatedByUser { get; set; }

    [MaxLength(100)]
    public string? UpdatedByProgram { get; set; }

    [Timestamp]
    public byte[] SystemTimestamp { get; set; } = null!;
}
