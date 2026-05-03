namespace YourApp.Web.Pages.Activities;

public sealed class IndexModel : PageModel
{
    private readonly IActivityRepository _repo;

    public IndexModel(IActivityRepository repo) => _repo = repo;

    public ActivityListViewModel ActivityList { get; set; } = new();

    public async Task OnGetAsync(CancellationToken ct)
    {
        var activities = await _repo.GetActiveAsync(ct);
        ActivityList = new ActivityListViewModel
        {
            Items = activities.Select(a => a.ToReadDto()).ToList(),
            TotalCount = activities.Count
        };
    }
}
