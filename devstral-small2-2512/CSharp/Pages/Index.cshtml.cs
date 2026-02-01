using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProjectManagement.Data.Repositories;
using ProjectManagement.ViewModels;

namespace ProjectManagement.Pages.Activities
{
    public class IndexModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public IndexModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        public ActivityListViewModel ViewModel { get; set; } = new ActivityListViewModel();

        public async Task OnGetAsync([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 10)
        {
            var activities = await _repository.GetAllAsync();
            var activeActivities = activities.Where(a => a.ActiveFlag && a.SystemDeleteFlag == "N");

            ViewModel.Activities = activeActivities
                .OrderByDescending(a => a.CreatedDateTime)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .Select(a => new ActivitySummaryViewModel
                {
                    ActivityId = a.ActivityId,
                    Name = a.Name,
                    Description = a.Description,
                    StartDate = a.StartDate,
                    TargetDate = a.TargetDate,
                    ProgressStatus = a.ProgressStatus,
                    ActivityPoints = a.ActivityPoints,
                    ActiveFlag = a.ActiveFlag
                })
                .ToList();

            ViewModel.TotalCount = activeActivities.Count();
            ViewModel.PageNumber = pageNumber;
            ViewModel.PageSize = pageSize;
        }
    }
}
