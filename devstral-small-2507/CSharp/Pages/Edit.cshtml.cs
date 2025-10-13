using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class EditModel : PageModel
{
    private readonly IActivityRepository _repository;

    public EditModel(IActivityRepository repository)
    {
        _repository = repository;
    }

    [BindProperty]
    public UpdateActivityViewModel Activity { get; set; }

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
        if (!ModelState.IsValid)
        {
            return Page();
        }

        var activity = await _repository.GetByIdAsync(Activity.ActivityId);
        if (activity == null)
        {
            return NotFound();
        }

        // Map properties from ViewModel to Model
        // ...

        activity.UpdatedDateTime = DateTime.UtcNow;
        _repository.Update(activity);

        return RedirectToPage("/Index");
    }
}
