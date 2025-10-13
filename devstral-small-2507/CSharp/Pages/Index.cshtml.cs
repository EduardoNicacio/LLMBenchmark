using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;

public class IndexModel : PageModel
{
    private readonly IActivityRepository _repository;

    public IndexModel(IActivityRepository repository)
    {
        _repository = repository;
    }

    public IEnumerable<ActivityViewModel> Activities { get; set; }

    public async Task OnGetAsync()
    {
        var activities = await _repository.GetAllActiveAsync();
        // Map from Activity to ActivityViewModel
        Activities = activities.Select(a => new ActivityViewModel
        {
            // Map properties
        });
    }
}
