using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using YourApp.Application.DTOs;
using YourApp.Infrastructure.Repositories;

namespace YourApp.Web.Pages.Activities
{
    public class IndexModel : PageModel
    {
        private readonly IActivityRepository _repo;

        public IndexModel(IActivityRepository repo)
        {
            _repo = repo;
        }

        [TempData]
        public string SuccessMessage { get; set; } = default!;

        public ActivityListViewModel Model { get; set; } = default!;

        private const int PageSize = 10;

        public async Task<IActionResult> OnGet(int page = 1)
        {
            var total = await _repo.GetAllAsync();
            var skip = (page - 1) * PageSize;
            var items = await _repo.GetAllAsync().Skip(skip).Take(PageSize).ToListAsync();

            Model = new ActivityListViewModel
            {
                Items = items,
                PageNumber = page,
                PageSize = PageSize,
                TotalCount = total.Count
            };
            return Page();
        }
    }
}
