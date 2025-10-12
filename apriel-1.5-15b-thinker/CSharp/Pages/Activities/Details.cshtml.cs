using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using System.Threading.Tasks;

namespace MyApp.Pages.Activities
{
    public class DetailsViewModel : PageModel
    {
        private readonly AppDbContext _context;

        public DetailsViewModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public Activity Activity { get; set; } = default!;

        public string ProjectName { get; set; } = string.Empty;
        public string MemberName { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public short? ProgressStatus { get; set; }
        public short? Priority { get; set; }

        // Authorization placeholder – in real app you'd check user roles.
        public bool CanDelete => true;

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
            MemberName   = activity.ProjectMember?.UserName ?? "N/A";

            Description    = activity.Description;
            StartDate      = activity.StartDate;
            TargetDate     = activity.TargetDate;
            EndDate        = activity.EndDate;

            ProgressStatus = activity.ProgressStatus;
            Priority       = activity.Priority;
        }
    }
}
