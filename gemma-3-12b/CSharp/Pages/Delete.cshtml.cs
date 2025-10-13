using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using MyApplication.Repositories;
using MyApplication.Models;

namespace MyApplication.Pages.Activities
{
    public class DeleteModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        [BindProperty]
        public Activity Activity { get; set; } = new();

        public DeleteModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
        }

        public void OnGet(Guid id)
        {
            Activity = _activityRepository.Get(id);
        }

        public IActionResult OnPost()
        {
            _activityRepository.Delete(Activity.ActivityId);
            return RedirectToPage("./Index");
        }
    }
}
