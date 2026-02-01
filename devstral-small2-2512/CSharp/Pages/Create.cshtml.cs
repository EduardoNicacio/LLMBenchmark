using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Models;
using ProjectManagement.ViewModels;

namespace ProjectManagement.Pages.Activities
{
    public class CreateModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public CreateModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        [BindProperty]
        public ActivityCreateViewModel Activity { get; set; } = new ActivityCreateViewModel();

        public IActionResult OnGet()
        {
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Activity.ProjectId,
                ProjectMemberId = Activity.ProjectMemberId,
                Name = Activity.Name,
                Description = Activity.Description,
                StartDate = Activity.StartDate,
                TargetDate = Activity.TargetDate,
                ProgressStatus = Activity.ProgressStatus,
                ActivityPoints = Activity.ActivityPoints,
                Priority = Activity.Priority,
                Risk = Activity.Risk,
                Tags = Activity.Tags,
                ActiveFlag = Activity.ActiveFlag,
                SystemDeleteFlag = "N",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = User.Identity?.Name ?? "System",
                CreatedByProgram = "WebApp"
            };

            await _repository.AddAsync(activity);
            return RedirectToPage("./Index");
        }
    }
}
