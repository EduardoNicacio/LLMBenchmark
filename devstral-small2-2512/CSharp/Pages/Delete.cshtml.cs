using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Models;

namespace ProjectManagement.Pages.Activities
{
    public class DeleteModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public DeleteModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        [BindProperty]
        public Activity Activity { get; set; } = new Activity();

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = await _repository.GetByIdAsync(id);
            if (activity == null)
            {
                return NotFound();
            }
            Activity = activity;
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            var activity = await _repository.GetByIdAsync(Activity.ActivityId);
            if (activity != null)
            {
                // Soft delete
                activity.SystemDeleteFlag = "Y";
                activity.UpdatedDateTime = DateTime.UtcNow;
                activity.UpdatedByUser = User.Identity?.Name ?? "System";
                activity.UpdatedByProgram = "WebApp";

                _repository.Update(activity);
            }

            return RedirectToPage("./Index");
        }
    }
}
