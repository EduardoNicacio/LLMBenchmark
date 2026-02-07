// Razor Pages: Delete.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using YourProject.Models;
using YourProject.Repositories;

namespace YourProject.Pages.Activities
{
    public class DeleteModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        public DeleteModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public Activity Activity { get; set; } = new();

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            Activity = await _activityRepository.GetByIdAsync(id);
            if (Activity == null)
                return NotFound();

            return Page();
        }

        public async Task<IActionResult> OnPostAsync(Guid id)
        {
            await _activityRepository.DeleteAsync(id);
            return RedirectToPage("./Index");
        }
    }
}
