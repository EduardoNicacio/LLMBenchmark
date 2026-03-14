// Pages/Activity/Create.cshtml.cs
using ActivityApp.Models;
using ActivityApp.Repositories;
using ActivityApp.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityApp.Pages.Activity
{
    public class CreateModel : PageModel
    {
        private readonly ActivityRepository _repo;
        public ActivityCreateViewModel ViewModel { get; set; } = new();

        public CreateModel(ActivityRepository repo)
        {
            _repo = repo;
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            var activity = new Activity
            {
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
                ActiveFlag = true,
                SystemDeleteFlag = false
            };

            await _repo.AddAsync(activity);
            return RedirectToPage("Index");
        }
    }
}