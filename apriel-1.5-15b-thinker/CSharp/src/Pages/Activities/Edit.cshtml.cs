// Views/Activities/Edit.cshtml.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data.Entities;
using MyApp.Data.Dtos;
using MyApp.Data.Repositories;
using MyApp.Pages.ViewModels;
using System.Threading.Tasks;

namespace MyApp.Pages;

public class EditModel : PageModel
{
    private readonly IActivityRepository _activityRepo;

    public EditModel(IActivityRepository activityRepo)
        => _activityRepo = activityRepo ?? throw new ArgumentNullException(nameof(activityRepo));

    [BindProperty(SupportsGet = true)]
    public UpdateActivityViewModel Model { get; set; } = new();

    public async Task<IActionResult> OnGetAsync(Guid ActivityId)
    {
        var entity = await _activityRepo.GetByIdAsync(ActivityId);
        if (entity == null) return NotFound();

        // Populate view model
        Model.ActivityId   = entity.ActivityId;
        Model.ProjectId   = entity.ProjectId.ToString();
        Model.ProjectMemberId= entity.ProjectMemberId.ToString();
        Model.Name         = entity.Name;
        Model.Description  = entity.Description;
        Model.StartDate    = entity.StartDate ?? DateTime.MinValue;
        Model.TargetDate   = entity.TargetDate ?? DateTime.MinValue;
        Model.ProgressStatus = entity.ProgressStatus;
        Model.ActivityPoints= entity.ActivityPoints;
        Model.Priority     = entity.Priority;
        Model.Risk         = entity.Risk;
        Model.Tags         = entity.Tags;
        Model.ActiveFlag   = entity.ActiveFlag;

        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid) return Page("Invalid");

        var activity = await _activityRepo.GetByIdAsync(Model.ActivityId);
        if (activity == null) return NotFound();

        // Apply updates
        activity.ProjectId      = Guid.Parse(Model.ProjectId);
        activity.ProjectMemberId= Guid.Parse(Model.ProjectMemberId);
        activity.Name          = Model.Name;
        activity.Description   = Model.Description;
        activity.StartDate     = Model.StartDate ?? activity.StartDate;
        activity.TargetDate    = Model.TargetDate ?? activity.TargetDate;
        activity.ProgressStatus = Model.ProgressStatus ?? activity.ProgressStatus;
        activity.ActivityPoints= Model.ActivityPoints ?? activity.ActivityPoints;
        activity.Priority      = Model.Priority ?? activity.Priority;
        activity.Risk          = Model.Risk ?? activity.Risk;
        activity.Tags          = Model.Tags;
        if (Model.ActiveFlag.HasValue) activity.ActiveFlag = Model.ActiveFlag.Value;

        await _activityRepo.UpdateAsync(activity);
        return RedirectToPage("./Index");
    }
}
