// DeleteModel.cs - For deleting activity (confirmation page)
using System.ComponentModel.DataAnnotations;
using YourApp.DTOs;

namespace YourApp.Pages

{
    public class DeleteModel : PageModel
    {
        [BindProperty]
        public UpdateActivityDto ActivityToDelete { get; set; } = new();

        private readonly IRepository<Activity> _activityRepository;

        public DeleteModel(IRepository<Activity> activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = _activityRepository.GetById(id);
            if (activity == null) return NotFound();
            
            ActivityToDelete.ActivityId = activity.ActivityId;
            ActivityToDelete.Name = activity.Name;
            ActivityToDelete.Description = activity.Description;

            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            var activity = _activityRepository.GetById(ActivityToDelete.ActivityId);
            if (activity == null) return NotFound();

            _activityRepository.Delete(activity.ActivityId); // Delete method expects id
            
            return RedirectToPage("./Index");
        }
    }
}
