// File: ViewModels/ActivityUpdateViewModel.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.ViewModels;

/// <summary>
/// View model for the Edit Razor Page.
/// </summary>
public class ActivityUpdateViewModel
{
    [Required]
    public Guid ActivityId { get; set; }

    // Same fields as CreateViewModel plus concurrency token.
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

    // Concurrency token for optimistic concurrency
    [Timestamp]
    public byte[] SystemTimestamp { get; set; } = default!;
}
