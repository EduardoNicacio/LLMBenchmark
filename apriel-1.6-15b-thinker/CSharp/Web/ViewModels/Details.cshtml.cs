using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using YourApp.Application.DTOs;
using YourApp.Infrastructure.Repositories;

namespace YourApp.Web.Pages.Activities
{
    public class DetailsModel : PageModel
    {
        private readonly IActivityRepository _repo;

        public DetailsModel(IActivityRepository repo)
        {
            _repo = repo;
        }

        public ActivityReadDto Model { get; set; } = default!;

        public async Task<IActionResult> OnGet(Guid id)
        {
            var activity = await _repo.GetByIdAsync(id);
            if (activity == null)
                return PageNotFound();

            Model = ActivityMappingExtensions.ToReadDto(activity);
            return Page();
        }
    }
}
