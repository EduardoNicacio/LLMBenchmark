// Pages/Activity/Delete.cshtml.cs
using ActivityApp.Models;
using ActivityApp.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityApp.Pages.Activity
{
    public class DeleteModel : PageModel
    {
        private readonly ActivityRepository _repo;
        public Guid Id { get; set; }

        public DeleteModel(ActivityRepository repo)
        {
            _repo = repo;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            Id = id;
            var activity = await _repo.GetByIdAsync(id);
            if (activity == null)
                return NotFound();
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            await _repo.DeleteAsync(Id);
            return RedirectToPage("Index");
        }
    }
}