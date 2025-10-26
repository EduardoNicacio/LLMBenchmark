// File: Pages/Activities/Delete.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;

namespace MyApp.Pages.Activities;

public class DeleteModel : PageModel
{
    private readonly IActivityRepository _repo;

    [BindProperty]
    public Guid ActivityId { get; set; }

    public string? ActivityName { get; set; }

    public DeleteModel(IActivityRepository repo)
    {
        _repo = repo;
    }

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        var activity = await _repo.GetAsync(id);
        if (activity == null) return NotFound();

        ActivityId = activity.ActivityId;
        ActivityName = activity.Name;

        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        var activity = await _repo.GetAsync(ActivityId);
        if (activity == null)
            return NotFound();

        // Soft delete
        activity.ActiveFlag = 0;
        activity.SystemDeleteFlag = 'Y';
        _repo.Update(activity);

        return RedirectToPage("Index");
    }
}
