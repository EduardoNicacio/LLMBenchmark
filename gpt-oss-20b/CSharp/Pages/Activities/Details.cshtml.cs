// File: Pages/Activities/Details.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data;
using MyApp.Models;

namespace MyApp.Pages.Activities;

public class DetailsModel : PageModel
{
    private readonly IActivityRepository _repo;

    public Activity? Activity { get; set; }

    public DetailsModel(IActivityRepository repo)
    {
        _repo = repo;
    }

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        Activity = await _repo.GetAsync(id);
        if (Activity == null) return NotFound();
        return Page();
    }
}
