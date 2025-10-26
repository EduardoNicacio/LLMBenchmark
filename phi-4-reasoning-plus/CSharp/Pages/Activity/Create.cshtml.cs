using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.ViewModels;
using MyApp.Models;
using MyApp.Repositories;

namespace MyApp.Pages.Activity
{
    // Razor Page model for creating an Activity.
    public class CreateModel : PageModel
    {
        private readonly IActivityRepository _repository;

        [BindProperty]
        public ActivityCreateViewModel ViewModel { get; set; } = new ActivityCreateViewModel();

        public CreateModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        // GET: /activity/create
        public void OnGet() { }

        // POST: /activity/create
        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
                return Page();

            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = ViewModel.ProjectId,
                ProjectMemberId = ViewModel.ProjectMemberId,
                Name = ViewModel.Name,
                Description = ViewModel.Description,
                StartDate = ViewModel.StartDate,
                TargetDate = ViewModel.TargetDate,
                EndDate = ViewModel.EndDate,
                ProgressStatus = ViewModel.ProgressStatus,
                ActivityPoints = ViewModel.ActivityPoints,
                Priority = ViewModel.Priority,
                Risk = ViewModel.Risk,
                Tags = ViewModel.Tags,
                ActiveFlag = ViewModel.ActiveFlag,
                SystemDeleteFlag = ViewModel.SystemDeleteFlag,
                CreatedDateTime = DateTime.UtcNow, // Or use a service for the current time.
                CreatedByUser = "CurrentUser",     // Replace with actual user info.
                CreatedByProgram = "RazorPages"
            };

            _repository.Add(activity);
            _repository.SaveChangesAsync().Wait();

            TempData["SuccessMessage"] = "Activity created successfully.";
            return RedirectToPage("./Index");
        }
    }
}