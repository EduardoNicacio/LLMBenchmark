// File: DTOs/ActivityUpdateDto.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.DTOs;

/// <summary>
/// Payload for updating an existing Activity.
/// </summary>
public class ActivityUpdateDto
{
    [Required]
    public Guid ActivityId { get; set; }

    // All updatable fields – same as CreateDto.
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

    public byte? ProgressStatus { get; set; }
    public short? ActivityPoints { get; set; }
    public byte? Priority { get; set; }
    public byte? Risk { get; set; }

    [StringLength(200)]
    public string? Tags { get; set; }

    // Concurrency token to protect against lost updates
    [Timestamp]
    public byte[] SystemTimestamp { get; set; } = default!;
}
