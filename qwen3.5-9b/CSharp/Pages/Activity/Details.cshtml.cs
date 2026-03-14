// Pages/Activity/Details.cshtml.cs
using ActivityApp.Models;
using ActivityApp.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityApp.Pages.Activity
{
    public class DetailsModel : PageModel
    {
        private readonly ActivityRepository _repo;
        public Activity Activity { get; set; } = new();

        public DetailsModel(ActivityRepository repo)
        {
            _repo = repo;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            Activity = await _repo.GetByIdAsync(id);
            if (Activity == null)
                return NotFound();
            return Page();
        }
    }
}