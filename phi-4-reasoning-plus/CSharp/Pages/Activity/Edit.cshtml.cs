using System;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.ViewModels;
using MyApp.Models;
using MyApp.Repositories;

namespace MyApp.Pages.Activity
{
    // Razor Page model for editing an Activity.
    public class EditModel : PageModel
    {
        private readonly IActivityRepository _repository;

        [BindProperty]
        public ActivityUpdateViewModel ViewModel { get; set; } = new ActivityUpdateViewModel();

        public Guid Id { get; private set; }

        public EditModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        // GET: /activity/edit/{id}
        public IActionResult OnGet(Guid id)
        {
            var activity = _repository.GetByIdAsync(id).Result;
            if (activity == null)
                return NotFound();

            Id = id;
            ViewModel.Name = activity.Name;
            ViewModel.Description = activity.Description;
            // Map additional properties as needed.
            return Page();
        }

        // POST: /activity/edit/{id}
        public IActionResult OnPost()
        {
            var activity = _repository.GetByIdAsync(ViewModel.ActivityId).Result;
            if (activity == null)
                return NotFound();

            activity.Name = ViewModel.Name ?? activity.Name;
            activity.Description = ViewModel.Description ?? activity.Description;
            // Map additional properties as needed.

            _repository.Update(activity);
            _repository.SaveChangesAsync().Wait();

            TempData["SuccessMessage"] = "Activity updated successfully.";
            return RedirectToPage("./Details", new { id = activity.ActivityId });
        }
    }
}