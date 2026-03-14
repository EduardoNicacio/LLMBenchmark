// Pages/Activity/Index.cshtml.cs
using ActivityApp.Models;
using ActivityApp.Repositories;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityApp.Pages.Activity
{
    public class IndexModel : PageModel
    {
        private readonly ActivityRepository _repo;

        public IndexModel(ActivityRepository repo)
        {
            _repo = repo;
        }

        public IEnumerable<Activity> Activities { get; set; } = new List<Activity>();

        public async Task OnGetAsync()
        {
            Activities = await _repo.GetAllAsync();
        }
    }
}