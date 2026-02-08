using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Threading.Tasks;

public class IndexModel : PageModel
{
    private readonly IActivityRepository _repository;

    public IndexModel(IActivityRepository repository)
    {
        _repository = repository;
    }

    public ListActivitiesViewModel ViewModel { get; set; } = new();

    public async Task OnGetAsync()
    {
        var activities = await _repository.GetAllAsync();
        ViewModel.Activities = activities.Where(a => !a.SystemDeleteFlag)
            .Select(a => new ReadActivityDto
            {
                ActivityId = a.ActivityId,
                ProjectId = a.ProjectId,
                ProjectMemberId = a.ProjectMemberId,
                Name = a.Name,
                Description = a.Description,
                StartDate = a.StartDate,
                TargetDate = a.TargetDate,
                ProgressStatus = a.ProgressStatus,
                ActiveFlag = a.ActiveFlag,
                IsDeleted = a.SystemDeleteFlag
            });
    }
}
