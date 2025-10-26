// File: Models/Activity.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyApp.Models;

/// <summary>
/// Entity that maps directly to dbo.Activity.
/// </summary>
[Table("Activity", Schema = "dbo")]
public class Activity
{
    [Key]
    public Guid ActivityId { get; set; }

    [Required]
    public Guid ProjectId { get; set; }

    [Required]
    public Guid ProjectMemberId { get; set; }

    [Required, StringLength(128)]
    public string Name { get; set; } = default!;

    [Required, StringLength(4000)]
    public string Description { get; set; } = default!;

    public DateTime? StartDate { get; set; }
    public DateTime? TargetDate { get; set; }
    public DateTime? EndDate { get; set; }

    public byte? ProgressStatus { get; set; }   // tinyint
    public short? ActivityPoints { get; set; }  // smallint
    public byte? Priority { get; set; }         // tinyint
    public byte? Risk { get; set; }             // tinyint

    [StringLength(200)]
    public string? Tags { get; set; }

    [Required]
    public byte ActiveFlag { get; set; }        // tinyint

    [Required, StringLength(1)]
    public char SystemDeleteFlag { get; set; }  // char(1)

    [Required]
    public DateTime CreatedDateTime { get; set; }

    [Required, StringLength(100)]
    public string CreatedByUser { get; set; } = default!;

    [Required, StringLength(100)]
    public string CreatedByProgram { get; set; } = default!;

    public DateTime? UpdatedDateTime { get; set; }

    [StringLength(100)]
    public string? UpdatedByUser { get; set; }

    [StringLength(100)]
    public string? UpdatedByProgram { get; set; }

    // Concurrency token
    [Timestamp]
    public byte[] SystemTimestamp { get; set; } = default!;
}
