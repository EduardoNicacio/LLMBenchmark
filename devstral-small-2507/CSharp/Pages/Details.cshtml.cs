using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class DetailsModel : PageModel
{
    private readonly IActivityRepository _repository;

    public DetailsModel(IActivityRepository repository)
    {
        _repository = repository;
    }

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
}
