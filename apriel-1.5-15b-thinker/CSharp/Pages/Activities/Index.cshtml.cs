using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Pages.Activities
{
    public class IndexModel : PageModel
    {
        private readonly AppDbContext _context;
        public const int PageSize = 10;

        public IndexModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public int? Page { get; set; } = 1;

        public ListViewModel Activities { get; set; } = new();

        public async Task OnGetAsync()
        {
            var totalCount = await _context.Activities.CountAsync();
            var pageItems = await _context.Activities
                .OrderBy(a => a.CreatedDateTime)
                .Skip(((Page ?? 1) - 1) * PageSize)
                .ToListAsync();

            // For demo, we will use navigation properties to get project/member names.
            foreach (var activity in pageItems)
            {
                activity.ProjectName = activity.Project?.Name ?? "N/A";
                activity.MemberName   = activity.ProjectMember?.UserName ?? "N/A";
            }

            Activities.TotalCount = totalCount;
            Activities.PageSize  = PageSize;
            Activities.Activities = new List<ActivityDto>(pageItems);

            // Pagination logic
            if (Activities.Activities.Count == 0 && Page.HasValue)
                Page = null; // reset to first page when no items

        }
    }

    public class ActivityDto
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; } = null!;
        public string ProjectName { get; set; } = null!;
        public string MemberName { get; set; } = null!;
        public short? ProgressStatus { get; set; }
        public DateTime CreatedDateTime { get; set; }

        // Additional properties for convenience
    }
}
