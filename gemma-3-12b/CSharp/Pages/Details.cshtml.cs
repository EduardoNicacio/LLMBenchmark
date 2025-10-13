using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using MyApplication.Repositories;
using MyApplication.Models;

namespace MyApplication.Pages.Activities
{
    public class DetailsModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        [BindProperty]
        public Activity Activity { get; set; } = new();

        public DetailsModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
        }

        public void OnGet(Guid id)
        {
            Activity = _activityRepository.Get(id);
        }
    }
}
