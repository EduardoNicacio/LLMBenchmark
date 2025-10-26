// File: ViewModels/ActivityListViewModel.cs
using System;

namespace MyApp.ViewModels;

/// <summary>
/// Minimal view model used by the Index page to list activities.
/// </summary>
public class ActivityListViewModel
{
    public Guid ActivityId { get; set; }
    public string Name { get; set; } = default!;
    public DateTime? StartDate { get; set; }
    public DateTime? TargetDate { get; set; }
    public DateTime? EndDate { get; set; }

    public byte? ProgressStatus { get; set; }
    public byte? Priority { get; set; }
    public byte? Risk { get; set; }

    public string? Tags { get; set; }
    public byte ActiveFlag { get; set; }

    public DateTime CreatedDateTime { get; set; }
}
