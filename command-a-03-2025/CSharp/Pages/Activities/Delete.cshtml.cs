using ActivityTracker.Models;
using ActivityTracker.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Threading.Tasks;

namespace ActivityTracker.Pages.Activities
{
    public class DeleteModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public DeleteModel(IActivityRepository repository)
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

        public async Task<IActionResult> OnPostAsync(Guid id)
        {
            Activity = await _repository.GetByIdAsync(id);
            if (Activity == null)
            {
                return NotFound();
            }

            await _repository.DeleteAsync(Activity);
            return RedirectToPage("./Index");
        }
    }
}
