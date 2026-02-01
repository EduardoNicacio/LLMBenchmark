using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Models;
using ProjectManagement.ViewModels;

namespace ProjectManagement.Pages.Activities
{
    public class EditModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public EditModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        [BindProperty]
        public ActivityUpdateViewModel Activity { get; set; } = new ActivityUpdateViewModel();

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = await _repository.GetByIdAsync(id);
            if (activity == null)
            {
                return NotFound();
            }

            Activity.ActivityId = activity.ActivityId;
            Activity.Name = activity.Name;
            Activity.Description = activity.Description;
            Activity.StartDate = activity.StartDate;
            Activity.TargetDate = activity.TargetDate;
            Activity.ProgressStatus = activity.ProgressStatus;
            Activity.ActivityPoints = activity.ActivityPoints;
            Activity.Priority = activity.Priority;
            Activity.Risk = activity.Risk;
            Activity.Tags = activity.Tags;
            Activity.ActiveFlag = activity.ActiveFlag;

            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            var existingActivity = await _repository.GetByIdAsync(Activity.ActivityId);
            if (existingActivity == null)
            {
                return NotFound();
            }

            // Update fields
            existingActivity.Name = Activity.Name;
            existingActivity.Description = Activity.Description;
            existingActivity.StartDate = Activity.StartDate;
            existingActivity.TargetDate = Activity.TargetDate;
            existingActivity.ProgressStatus = Activity.ProgressStatus;
            existingActivity.ActivityPoints = Activity.ActivityPoints;
            existingActivity.Priority = Activity.Priority;
            existingActivity.Risk = Activity.Risk;
            existingActivity.Tags = Activity.Tags;
            existingActivity.ActiveFlag = Activity.ActiveFlag;
            existingActivity.UpdatedDateTime = DateTime.UtcNow;
            existingActivity.UpdatedByUser = User.Identity?.Name ?? "System";
            existingActivity.UpdatedByProgram = "WebApp";

            _repository.Update(existingActivity);
            return RedirectToPage("./Index");
        }
    }
}
