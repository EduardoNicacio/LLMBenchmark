// File: Pages/Activities/Edit.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.DTOs;
using MyApp.ViewModels;

namespace MyApp.Pages.Activities;

public class EditModel : PageModel
{
    private readonly IActivityRepository _repo;

    [BindProperty]
    public ActivityUpdateViewModel Activity { get; set; } = new();

    public EditModel(IActivityRepository repo)
    {
        _repo = repo;
    }

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        var existing = await _repo.GetAsync(id);
        if (existing == null) return NotFound();

        Activity = new ActivityUpdateViewModel
        {
            ActivityId = existing.ActivityId,
            ProjectId = existing.ProjectId,
            ProjectMemberId = existing.ProjectMemberId,
            Name = existing.Name,
            Description = existing.Description,
            StartDate = existing.StartDate,
            TargetDate = existing.TargetDate,
            EndDate = existing.EndDate,
            ProgressStatus = existing.ProgressStatus,
            ActivityPoints = existing.ActivityPoints,
            Priority = existing.Priority,
            Risk = existing.Risk,
            Tags = existing.Tags,
            SystemTimestamp = existing.SystemTimestamp
        };

        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
            return Page();

        var existing = await _repo.GetAsync(Activity.ActivityId);
        if (existing == null) return NotFound();

        // Map changes
        existing.ProjectId = Activity.ProjectId;
        existing.ProjectMemberId = Activity.ProjectMemberId;
        existing.Name = Activity.Name;
        existing.Description = Activity.Description;
        existing.StartDate = Activity.StartDate;
        existing.TargetDate = Activity.TargetDate;
        existing.EndDate = Activity.EndDate;
        existing.ProgressStatus = Activity.ProgressStatus;
        existing.ActivityPoints = Activity.ActivityPoints;
        existing.Priority = Activity.Priority;
        existing.Risk = Activity.Risk;
        existing.Tags = Activity.Tags;

        try
        {
            _repo.Update(existing);
        }
        catch (DbUpdateConcurrencyException)
        {
            ModelState.AddModelError(string.Empty, "The record you attempted to edit was modified by another user.");
            return Page();
        }

        return RedirectToPage("Index");
    }
}
