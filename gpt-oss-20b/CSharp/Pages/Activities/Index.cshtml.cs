// File: Pages/Activities/Index.cshtml.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.ViewModels;

namespace MyApp.Pages.Activities;

public class IndexModel : PageModel
{
    private readonly IActivityRepository _repo;

    public IEnumerable<ActivityListViewModel> Activities { get; set; } = Enumerable.Empty<ActivityListViewModel>();

    public IndexModel(IActivityRepository repo)
    {
        _repo = repo;
    }

    public async Task OnGetAsync()
    {
        var activities = await _repo.GetAllAsync();
        // Map to list view model
        Activities = activities.Select(a => new ActivityListViewModel
        {
            ActivityId = a.ActivityId,
            Name = a.Name,
            StartDate = a.StartDate,
            TargetDate = a.TargetDate,
            EndDate = a.EndDate,
            ProgressStatus = a.ProgressStatus,
            Priority = a.Priority,
            Risk = a.Risk,
            Tags = a.Tags,
            ActiveFlag = a.ActiveFlag,
            CreatedDateTime = a.CreatedDateTime
        });
    }
}
