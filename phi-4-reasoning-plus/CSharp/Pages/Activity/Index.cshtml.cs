using System;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MyApp.ViewModels;
using MyApp.Models;
using MyApp.Repositories;

namespace MyApp.Pages.Activity
{
    // Razor Page model for listing Activities.
    public class IndexModel : PageModel
    {
        private readonly IActivityRepository _repository;

        public ActivityListViewModel ViewModel { get; set; } = new ActivityListViewModel();

        public IndexModel(IActivityRepository repository)
        {
            _repository = repository;
        }

        // GET: /activity/index
        public void OnGet()
        {
            var activities = _repository.GetAllAsync().Result;

            // Map to summary view models.
            ViewModel.Activities = new System.Collections.Generic.List<ActivitySummary>();
            foreach (var activity in activities)
            {
                ViewModel.Activities.Add(new ActivitySummary
                {
                    ActivityId = activity.ActivityId,
                    Name = activity.Name,
                    Description = activity.Description,
                    CreatedDateTime = activity.CreatedDateTime
                });
            }
        }
    }
}