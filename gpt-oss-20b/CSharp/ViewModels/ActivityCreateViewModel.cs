// File: ViewModels/ActivityCreateViewModel.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.ViewModels;

/// <summary>
/// View model for the Create Razor Page.
/// </summary>
public class ActivityCreateViewModel
{
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

    // Flags are hidden or managed server‑side.
}
