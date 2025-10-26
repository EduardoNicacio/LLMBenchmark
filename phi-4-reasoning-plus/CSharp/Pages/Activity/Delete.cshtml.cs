using System;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.Models;
using MyApp.Repositories;

namespace MyApp.Pages.Activity
{
    // Razor Page model for deleting an Activity.
    public class DeleteModel : PageModel
    {
        private readonly IActivityRepository _repository;

        [BindProperty]
        public ActivityReadDto ViewModel { get; set; } = new ActivityReadDto();

        public Guid Id { get; private set; }

        public DeleteModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        // GET: /activity/delete/{id}
        public IActionResult OnGet(Guid id)
        {
            var activity = _repository.GetByIdAsync(id).Result;
            if (activity == null)
                return NotFound();

            Id = id;
            ViewModel.ActivityId = activity.ActivityId;
            ViewModel.Name = activity.Name;
            // Map additional fields as needed.

            return Page();
        }

        // POST: /activity/delete/{id}
        public IActionResult OnPost()
        {
            var activity = _repository.GetByIdAsync(ViewModel.ActivityId).Result;
            if (activity == null)
                return NotFound();

            _repository.Delete(activity);
            _repository.SaveChangesAsync().Wait();

            TempData["SuccessMessage"] = "Activity deleted successfully.";
            return RedirectToPage("./Index");
        }
    }
}