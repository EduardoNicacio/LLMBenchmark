using ActivityManagement.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityManagement.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ApplicationDbContext _context;

        public List<Activity> Activities { get; set; }

        public IndexModel(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task OnGetAsync()
        {
            Activities = await _context.Activities.ToListAsync();
        }
    }
}
