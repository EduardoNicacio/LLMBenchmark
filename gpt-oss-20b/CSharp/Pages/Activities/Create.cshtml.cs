// File: Pages/Activities/Create.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.DTOs;
using MyApp.ViewModels;

namespace MyApp.Pages.Activities;

public class CreateModel : PageModel
{
    private readonly IActivityRepository _repo;

    [BindProperty]
    public ActivityCreateViewModel Activity { get; set; } = new();

    public CreateModel(IActivityRepository repo)
    {
        _repo = repo;
    }

    public void OnGet()
    {
        // Load any dropdowns or related data here
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
            return Page();

        var dto = new ActivityCreateDto
        {
            ProjectId = Activity.ProjectId,
            ProjectMemberId = Activity.ProjectMemberId,
            Name = Activity.Name,
            Description = Activity.Description,
            StartDate = Activity.StartDate,
            TargetDate = Activity.TargetDate,
            EndDate = Activity.EndDate,
            ProgressStatus = Activity.ProgressStatus,
            ActivityPoints = Activity.ActivityPoints,
            Priority = Activity.Priority,
            Risk = Activity.Risk,
            Tags = Activity.Tags
        };

        await _repo.AddAsync(new Models.Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = dto.ProjectId,
            ProjectMemberId = dto.ProjectMemberId,
            Name = dto.Name,
            Description = dto.Description,
            StartDate = dto.StartDate,
            TargetDate = dto.TargetDate,
            EndDate = dto.EndDate,
            ProgressStatus = dto.ProgressStatus,
            ActivityPoints = dto.ActivityPoints,
            Priority = dto.Priority,
            Risk = dto.Risk,
            Tags = dto.Tags,
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "system",
            CreatedByProgram = "RazorPages"
        });

        return RedirectToPage("Index");
    }
}
