// Razor Pages: Edit.cshtml.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using YourProject.DTOs;
using YourProject.Models;
using YourProject.Repositories;

namespace YourProject.Pages.Activities
{
    public class EditModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        public EditModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository;
        }

        [BindProperty]
        public UpdateActivityViewModel Model { get; set; } = new();

        public Activity Activity { get; set; } = new();

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            Activity = await _activityRepository.GetByIdAsync(id);
            if (Activity == null)
                return NotFound();

            Model = new UpdateActivityViewModel
            {
                ProjectId = Activity.ProjectId,
                ProjectMemberId = Activity.ProjectMemberId,
                Name = Activity.Name,
                Description = Activity.Description,
                StartDate = Activity.StartDate,
                TargetDate = Activity.TargetDate,
                EndDate = Activity.EndDate,
                ProgressStatus = Activity.ProgressStatus,
                ActivityPoints = Activity.ActivityPoints,
                Priority = Activity.Priority,
                Risk = Activity.Risk,
                Tags = Activity.Tags
            };

            return Page();
        }

        public async Task<IActionResult> OnPostAsync(Guid id)
        {
            if (!ModelState.IsValid)
                return Page();

            var activity = await _activityRepository.GetByIdAsync(id);
            if (activity == null)
                return NotFound();

            activity.ProjectId = Model.ProjectId;
            activity.ProjectMemberId = Model.ProjectMemberId;
            activity.Name = Model.Name ?? activity.Name;
            activity.Description = Model.Description ?? activity.Description;
            activity.StartDate = Model.StartDate;
            activity.TargetDate = Model.TargetDate;
            activity.EndDate = Model.EndDate;
            activity.ProgressStatus = Model.ProgressStatus;
            activity.ActivityPoints = Model.ActivityPoints;
            activity.Priority = Model.Priority;
            activity.Risk = Model.Risk;
            activity.Tags = Model.Tags;

            activity.UpdatedDateTime = DateTime.UtcNow;
            activity.UpdatedByUser = "RazorPage";
            activity.UpdatedByProgram = "ASP.NET";

            await _activityRepository.UpdateAsync(activity);
            return RedirectToPage("./Index");
        }
    }
}
