// Pages/Activity/Edit.cshtml.cs
using ActivityApp.Models;
using ActivityApp.Repositories;
using ActivityApp.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace ActivityApp.Pages.Activity
{
    public class EditModel : PageModel
    {
        private readonly ActivityRepository _repo;
        public ActivityEditViewModel ViewModel { get; set; } = new();

        public EditModel(ActivityRepository repo)
        {
            _repo = repo;
        }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var activity = await _repo.GetByIdAsync(id);
            if (activity == null)
                return NotFound();

            ViewModel.ActivityId = activity.ActivityId;
            ViewModel.Name = activity.Name;
            ViewModel.Description = activity.Description;
            ViewModel.StartDate = activity.StartDate;
            ViewModel.TargetDate = activity.TargetDate;
            ViewModel.EndDate = activity.EndDate;
            ViewModel.ProgressStatus = activity.ProgressStatus;
            ViewModel.ActivityPoints = activity.ActivityPoints;
            ViewModel.Priority = activity.Priority;
            ViewModel.Risk = activity.Risk;
            ViewModel.Tags = activity.Tags;
            ViewModel.ActiveFlag = activity.ActiveFlag;

            return Page();
        }

        public async Task<IActionResult> OnPostAsync(Guid id)
        {
            if (!ModelState.IsValid)
                return Page();

            var activity = await _repo.GetByIdAsync(id);
            if (activity == null)
                return NotFound();

            activity.Name = ViewModel.Name;
            activity.Description = ViewModel.Description;
            activity.StartDate = ViewModel.StartDate;
            activity.TargetDate = ViewModel.TargetDate;
            activity.EndDate = ViewModel.EndDate;
            activity.ProgressStatus = ViewModel.ProgressStatus;
            activity.ActivityPoints = ViewModel.ActivityPoints;
            activity.Priority = ViewModel.Priority;
            activity.Risk = ViewModel.Risk;
            activity.Tags = ViewModel.Tags;
            activity.ActiveFlag = ViewModel.ActiveFlag;

            await _repo.UpdateAsync(activity);
            return RedirectToPage("Index");
        }
    }
}