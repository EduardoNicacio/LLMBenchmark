using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using YourApp.Infrastructure.Repositories;

namespace YourApp.Web.Pages.Activities
{
    public class DeleteModel : PageModel
    {
        private readonly IActivityRepository _repo;

        [BindProperty]
        public Guid ActivityId { get; set; }

        public DeleteModel(IActivityRepository repo)
        {
            _repo = repo;
        }

        public async Task<IActionResult> OnPost()
        {
            await _repo.DeleteAsync(ActivityId);
            TempData["success"] = "Activity soft‑deleted.";
            return RedirectToPage("Index");
        }
    }
}
