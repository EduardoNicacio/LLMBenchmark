// Views/Activities/Delete.cshtml.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data.Entities;
using MyApp.Data.Repositories;
using System.Threading.Tasks;

namespace MyApp.Pages;

public class DeleteModel : PageModel
{
    private readonly IActivityRepository _activityRepo;

    public DeleteModel(IActivityRepository activityRepo)
        => _activityRepo = activityRepo ?? throw new ArgumentNullException(nameof(activityRepo));

    [BindProperty]
    public Guid ActivityId { get; set; }

    public async Task<IActionResult> OnPostAsync()
    {
        var entity = await _activityRepo.GetByIdAsync(ActivityId);
        if (entity == null) return NotFound();

        await _activityRepo.DeleteAsync(entity);
        return Page("./Index");
    }
}
