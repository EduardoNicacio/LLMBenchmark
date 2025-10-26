using ActivityManagement.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityManagement.Pages
{
    public class CreateModel : PageModel
    {
        private readonly ApplicationDbContext _context;

        [BindProperty]
        public Activity Activity { get; set; }

        public CreateModel(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            Activity.CreatedDateTime = DateTime.UtcNow;
            Activity.CreatedByUser = "System";
            Activity.CreatedByProgram = "RazorPage";

            _context.Activities.Add(Activity);
            await _context.SaveChangesAsync();

            return RedirectToPage("./Index");
        }
    }
}
