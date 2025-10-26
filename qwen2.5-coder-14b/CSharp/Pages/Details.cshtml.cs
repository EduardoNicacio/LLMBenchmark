using ActivityManagement.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityManagement.Pages
{
    public class DetailsModel : PageModel
    {
        private readonly ApplicationDbContext _context;

        public Activity Activity { get; set; }

        public DetailsModel(ApplicationDbContext context)
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
    }
}
