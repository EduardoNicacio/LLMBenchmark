using ActivityTracker.Models;
using ActivityTracker.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Threading.Tasks;

namespace ActivityTracker.Pages.Activities
{
    public class EditModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public EditModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        [BindProperty]
        public Activity Activity { get; set; }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            Activity = await _repository.GetByIdAsync(id);
            if (Activity == null)
            {
                return NotFound();
            }
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            Activity.UpdatedDateTime = DateTime.UtcNow;
            Activity.UpdatedByUser = User.Identity.Name;
            Activity.UpdatedByProgram = "WebApplication";

            await _repository.UpdateAsync(Activity);
            return RedirectToPage("./Index");
        }
    }
}
