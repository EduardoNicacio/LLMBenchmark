using ActivityManagement.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityManagement.Pages
{
    public class EditModel : PageModel
    {
        private readonly ApplicationDbContext _context;

        [BindProperty]
        public Activity Activity { get; set; }

        public Guid Id { get; private set; }

        public EditModel(ApplicationDbContext context)
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
            Id = id;

            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            var activityToUpdate = await _context.Activities.FindAsync(Id);
            if (activityToUpdate == null)
                return NotFound();

            activityToUpdate.Name = Activity.Name;
            activityToUpdate.Description = Activity.Description;
            // Update other fields similarly
            activityToUpdate.UpdatedDateTime = DateTime.UtcNow;
            activityToUpdate.UpdatedByUser = "System";
            activityToUpdate.UpdatedByProgram = "RazorPage";

            _context.Activities.Update(activityToUpdate);
            await _context.SaveChangesAsync();

            return RedirectToPage("./Index");
        }
    }
}
