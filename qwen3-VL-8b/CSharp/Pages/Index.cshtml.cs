// Razor Pages: Index.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using YourProject.Models;
using YourProject.Repositories;

namespace YourProject.Pages.Activities
{
    public class IndexModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        public IndexModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository;
        }

        public List<ListActivityViewModel> Activities { get; set; } = new();

        public async Task<IActionResult> OnGetAsync()
        {
            Activities = await _activityRepository.GetReadDtoListAsync();
            return Page();
        }
    }
}
