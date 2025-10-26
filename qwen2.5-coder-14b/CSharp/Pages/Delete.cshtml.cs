using ActivityManagement.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityManagement.Pages
{
    public class DeleteModel : PageModel
    {
        private readonly ApplicationDbContext _context;

        [BindProperty]
        public Activity Activity { get; set; }

        public DeleteModel(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            if (id == null || _context.Activities == null)
                return NotFound();

            var activity = await _context.Activities.FindAsync(id);

            if (activity == null)
                return NotFound();

            Activity = activity;

            return Page();
        }

        public async Task<IActionResult> OnPostAsync(Guid id)
        {
            if (id == null || _context.Activities == null)
                return NotFound();

            var activity = await _context.Activities.FindAsync(id);

            if (activity != null)
            {
                _context.Activities.Remove(activity);
                await _context.SaveChangesAsync();
            }

            return RedirectToPage("./Index");
        }
    }
}
