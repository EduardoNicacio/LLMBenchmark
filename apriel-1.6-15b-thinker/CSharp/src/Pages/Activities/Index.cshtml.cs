// Views/Activities/Index.cshtml.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Data.Dtos;
using MyApp.Pages.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Pages;

public class IndexModel : PageModel
{
    private readonly IActivityRepository _activityRepository;

    public IndexModel(IActivityRepository activityRepository)
    {
        _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
    }

    [BindProperty]
    public ListActivityViewModel Model { get; set; } = new();

    public async Task OnGetAsync()
    {
        var pageSize = Model.PageSize;
        var pageNumber = Model.PageNumber;

        // Simple pagination example
        var totalCount = await _activityRepository.GetAllAsync().CountAsync();
        var activities = await _activityRepository.GetAllWithDetailsAsync()
            .Skip(pageNumber * pageSize)
            .Take(pageSize)
            .ToListAsync();

        Model.Activities = activities;
    }
}
