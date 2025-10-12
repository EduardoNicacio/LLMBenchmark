using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using System.Threading.Tasks;

namespace MyApp.Pages.Activities
{
    public class DeleteViewModel : PageModel
    {
        private readonly AppDbContext _context;

        public DeleteViewModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public Activity Activity { get; set; } = default!;

        public string ProjectName { get; set; } = string.Empty;

        public async Task OnGetAsync(Guid activityId)
        {
            var activity = await _context.Activities
                .Where(a => a.ActivityId == activityId && !a.SystemDeleteFlag.Equals('Y'))
                .FirstOrDefaultAsync();

            if (activity == null)
            {
                // Not found – you could return 404 page.
                return;
            }

            Activity = activity;
            ProjectName = activity.Project?.Name ?? "N/A";
        }

        public async Task<IActionResult> OnPostAsync()
        {
            // Soft delete: set SystemDeleteFlag to 'Y' and UpdatedDateTime
            var activityToDelete = await _context.Activities
                .Where(a => a.ActivityId == Activity.ActivityId && !a.SystemDeleteFlag.Equals('Y'))
                .FirstOrDefaultAsync();

            if (activityToDelete == null)
                return Page(); // Already deleted or not found

            activityToDelete.SystemDeleteFlag = 'Y';
            activityToDelete.UpdatedDateTime   = DateTime.UtcNow;
            activityToDelete.UpdatedByUser     = "system";
            activityToDelete.UpdatedByProgram  = "DeletePage";

            await _context.SaveChangesAsync();

            return Page("/Index");
        }
    }
}
