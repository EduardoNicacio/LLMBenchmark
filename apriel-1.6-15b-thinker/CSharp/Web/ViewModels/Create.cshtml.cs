using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using YourApp.Infrastructure.Repositories;
using YourApp.Web.ViewModels;

namespace YourApp.Web.Pages.Activities
{
    public class CreateModel : PageModel
    {
        private readonly IActivityRepository _repo;

        public CreateModel(IActivityRepository repo)
        {
            _repo = repo;
        }

        [BindProperty]
        public ActivityCreateViewModel Model { get; set; } = default!;

        public void OnGet()
        {
            // No pre‑population needed for demo.
        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
                return Page();

            var activity = ActivityMappingExtensions.ToEntity(Model);
            await _repo.AddAsync(activity);
            await _repo.SaveChangesAsync();

            TempData["success"] = "Activity created successfully.";
            return RedirectToPage("Index");
        }
    }
}
