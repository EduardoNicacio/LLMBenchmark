// Razor Pages: Create.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using YourProject.DTOs;
using YourProject.Models;
using YourProject.Repositories;

namespace YourProject.Pages.Activities
{
    public class CreateModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        public CreateModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository;
        }

        [BindProperty]
        public CreateActivityViewModel Model { get; set; } = new();

        public void OnGet()
        {
            // You can load dropdowns or other data here
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
                return Page();

            var dto = new CreateActivityDto
            {
                ProjectId = Model.ProjectId,
                ProjectMemberId = Model.ProjectMemberId,
                Name = Model.Name,
                Description = Model.Description,
                StartDate = Model.StartDate,
                TargetDate = Model.TargetDate,
                EndDate = Model.EndDate,
                ProgressStatus = Model.ProgressStatus,
                ActivityPoints = Model.ActivityPoints,
                Priority = Model.Priority,
                Risk = Model.Risk,
                Tags = Model.Tags
            };

            // Create the activity
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = dto.ProjectId,
                ProjectMemberId = dto.ProjectMemberId,
                Name = dto.Name,
                Description = dto.Description,
                StartDate = dto.StartDate,
                TargetDate = dto.TargetDate,
                EndDate = dto.EndDate,
                ProgressStatus = dto.ProgressStatus,
                ActivityPoints = dto.ActivityPoints,
                Priority = dto.Priority,
                Risk = dto.Risk,
                Tags = dto.Tags,
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "RazorPage",
                CreatedByProgram = "ASP.NET",
                UpdatedDateTime = null,
                UpdatedByUser = null,
                UpdatedByProgram = null,
                SystemTimestamp = new byte[8]
            };

            await _activityRepository.AddAsync(activity);
            return RedirectToPage("./Index");
        }
    }
}
