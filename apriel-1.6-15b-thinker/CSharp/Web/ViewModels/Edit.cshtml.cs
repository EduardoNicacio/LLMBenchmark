using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using YourApp.Domain.Entities;
using YourApp.Infrastructure.Repositories;
using YourApp.Web.ViewModels;

namespace YourApp.Web.Pages.Activities
{
    public class EditModel : PageModel
    {
        private readonly IActivityRepository _repo;

        public EditModel(IActivityRepository repo)
        {
            _repo = repo;
        }

        [BindProperty]
        public ActivityUpdateViewModel Model { get; set; } = default!;

        public async Task<IActionResult> OnGet()
        {
            var activity = await _repo.GetByIdAsync(Model.ActivityId);
            if (activity == null)
                return PageNotFound();

            // Populate view model
            Model.SystemTimestamp = activity.SystemTimestamp;
            ActivityMappingExtensions.ApplyUpdate(activity, new ActivityUpdateDto
            {
                ProjectId = activity.ProjectId,
                ProjectMemberId = activity.ProjectMemberId,
                Name = activity.Name,
                Description = activity.Description,
                StartDate = activity.StartDate,
                TargetDate = activity.TargetDate,
                EndDate = activity.EndDate,
                ProgressStatus = activity.ProgressStatus,
                ActivityPoints = activity.ActivityPoints,
                Priority = activity.Priority,
                Risk = activity.Risk,
                Tags = activity.Tags,
                ActiveFlag = activity.ActiveFlag
            });

            return Page();
        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
                return Page();

            var existing = await _repo.GetByIdAsync(Model.ActivityId);
            if (existing == null)
                return PageNotFound();

            ActivityMappingExtensions.ApplyUpdate(existing, Model);
            try
            {
                await _repo.UpdateAsync(existing);
                await _repo.SaveChangesAsync();
                TempData["success"] = "Activity updated.";
                return RedirectToPage("Index");
            }
            catch (DbUpdateConcurrencyException)
            {
                ModelState.AddModelError(string.Empty, "The activity has been modified by another user.");
                return Page();
            }
        }
    }
}
