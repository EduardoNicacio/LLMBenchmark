using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class DeleteModel : PageModel
{
    private readonly IActivityRepository _repository;

    public DeleteModel(IActivityRepository repository)
    {
        _repository = repository;
    }

    [BindProperty]
    public ActivityViewModel Activity { get; set; }

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        var activity = await _repository.GetByIdAsync(id);
        if (activity == null)
        {
            return NotFound();
        }

        // Map properties from Model to ViewModel
        // ...

        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        var activity = await _repository.GetByIdAsync(Activity.ActivityId);
        if (activity == null)
        {
            return NotFound();
        }

        // Soft delete
        activity.ActiveFlag = false;
        activity.SystemDeleteFlag = 'Y';
        _repository.Update(activity);

        return RedirectToPage("/Index");
    }
}
