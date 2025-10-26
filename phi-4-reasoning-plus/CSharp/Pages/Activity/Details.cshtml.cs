using System;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.ViewModels;
using MyApp.Models;
using MyApp.Repositories;

namespace MyApp.Pages.Activity
{
    // Razor Page model for displaying Activity details.
    public class DetailsModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public ActivityReadDto ViewModel { get; set; } = new ActivityReadDto();

        public Guid Id { get; private set; }

        public DetailsModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        // GET: /activity/details/{id}
        public IActionResult OnGet(Guid id)
        {
            var activity = _repository.GetByIdAsync(id).Result;
            if (activity == null)
                return NotFound();

            Id = id;
            ViewModel.ActivityId = activity.ActivityId;
            ViewModel.ProjectId = activity.ProjectId;
            ViewModel.ProjectMemberId = activity.ProjectMemberId;
            ViewModel.Name = activity.Name;
            ViewModel.Description = activity.Description;
            // Map additional fields as necessary.

            return Page();
        }
    }
}