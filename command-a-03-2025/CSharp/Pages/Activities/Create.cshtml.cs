using ActivityTracker.Models;
using ActivityTracker.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Threading.Tasks;

namespace ActivityTracker.Pages.Activities
{
    public class CreateModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public CreateModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        [BindProperty]
        public Activity Activity { get; set; }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            Activity.ActivityId = Guid.NewGuid();
            Activity.CreatedDateTime = DateTime.UtcNow;
            Activity.CreatedByUser = User.Identity.Name;
            Activity.CreatedByProgram = "WebApplication";

            await _repository.AddAsync(Activity);
            return RedirectToPage("./Index");
        }
    }
}
