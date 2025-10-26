public class IndexModel : PageModel
{
    public IActionResult OnGet()
    {
        // Logic for listing, possibly populating a ViewModel
        return Page();
    }

    [BindProperty]
    public ActivityViewModel ViewModel { get; set; } = new();

    public IActionResult OnPostCreate([FromForm] CreateDto activity)
    {
        var entity = AutoMapper.Mapper.Map<Activity>(activity);
        _repository.Add(entity); // Assuming an injected repository

        return RedirectToPage("./Index"); // Redirect to index after creation
    }

    // Similar methods for Edit...
}
