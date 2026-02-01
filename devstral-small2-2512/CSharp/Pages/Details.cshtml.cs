using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Models;

namespace ProjectManagement.Pages.Activities
{
    public class DetailsModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public DetailsModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        public Activity Activity { get; set; } = new Activity();

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = await _repository.GetByIdAsync(id);
            if (activity == null)
            {
                return NotFound();
            }
            Activity = activity;
            return Page();
        }
    }
}
