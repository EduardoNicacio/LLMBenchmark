using ActivityTracker.Repository;
using ActivityTracker.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ActivityTracker.Pages.Activities
{
    public class IndexModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public IndexModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        public IList<ListActivityViewModel> Activities { get; set; }

        public async Task OnGetAsync()
        {
            var activities = await _repository.GetAllAsync();
            Activities = activities.Select(a => new ListActivityViewModel
            {
                ActivityId = a.ActivityId,
                Name = a.Name,
                StartDate = a.StartDate,
                EndDate = a.EndDate,
                ProgressStatus = a.ProgressStatus
            }).ToList();
        }
    }
}
