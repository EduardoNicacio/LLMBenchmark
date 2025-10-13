// Views/Activities/Create.cshtml.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data.Entities;
using MyApp.Data.Dtos;
using MyApp.Data.Repositories;
using MyApp.Pages.ViewModels;
using System.Threading.Tasks;

namespace MyApp.Pages;

public class CreateModel : PageModel
{
    private readonly IActivityRepository _activityRepo;

    public CreateModel(IActivityRepository activityRepo)
    {
        _activityRepo = activityRepo ?? throw new ArgumentNullException(nameof(activityRepo));
    }

    [BindProperty]
    public ActivityCreateViewModel Model { get; set; } = new();

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid) return Page("Invalid");

        // Map view model to entity
        var activity = new Activity
        {
            ProjectId      = Guid.Parse(Model.ProjectId),
            ProjectMemberId= Guid.Parse(Model.ProjectMemberId),
            Name           = Model.Name,
            Description    = Model.Description,
            StartDate      = Model.StartDate ?? DateTime.MinValue,
            TargetDate     = Model.TargetDate ?? DateTime.MinValue,
            ProgressStatus = Model.ProgressStatus,
            ActivityPoints = Model.ActivityPoints,
            Priority       = Model.Priority,
            Risk           = Model.Risk,
            Tags           = Model.Tags,
            ActiveFlag     = Model.ActiveFlag,
            SystemDeleteFlag= 'N',
            CreatedDateTime  = DateTime.UtcNow,
            CreatedByUser    = "System",
            CreatedByProgram = "Razor Page"
        };

        await _activityRepo.AddAsync(activity);
        return RedirectToPage("./Index");
    }
}
