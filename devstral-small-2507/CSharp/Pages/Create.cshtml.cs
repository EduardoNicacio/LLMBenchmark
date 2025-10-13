using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class CreateModel : PageModel
{
    private readonly IActivityRepository _repository;

    public CreateModel(IActivityRepository repository)
    {
        _repository = repository;
    }

    [BindProperty]
    public CreateActivityViewModel Activity { get; set; }

    public IActionResult OnGet()
    {
        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        if (!ModelState.IsValid)
        {
            return Page();
        }

        var activity = new Activity
        {
            // Map properties from ViewModel to Model
            CreatedDateTime = DateTime.UtcNow,
            ActiveFlag = true,
            SystemDeleteFlag = 'N'
        };

        await _repository.AddAsync(activity);
        return RedirectToPage("/Index");
    }
}
