using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.ComponentModel.DataAnnotations;
using MyApplication.Repositories;
using MyApplication.Models;
using MyApplication.DTOs;

namespace MyApplication.Pages.Activities
{
    public class EditModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        [BindProperty]
        public ActivityUpdateDto Activity { get; set; } = new();

        public EditModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
        }

        public void OnGet()
        {
            // Load existing data
            Activity = new ActivityUpdateDto { ActivityId = Guid.NewGuid() }; // Replace with actual logic to fetch from repository
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _activityRepository.Update(Activity);
            return RedirectToPage("./Index");
        }
    }
}
