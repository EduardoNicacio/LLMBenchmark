using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.ComponentModel.DataAnnotations;
using MyApplication.Repositories;
using MyApplication.Models;
using MyApplication.DTOs;

namespace MyApplication.Pages.Activities
{
    public class CreateModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        [BindProperty]
        public ActivityCreateDto Activity { get; set; } = new();

        public CreateModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
        }

        public void OnGet()
        {
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _activityRepository.Add(Activity);
            return RedirectToPage("./Index");
        }
    }
}
