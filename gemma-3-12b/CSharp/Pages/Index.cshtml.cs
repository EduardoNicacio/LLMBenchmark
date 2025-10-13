using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;
using MyApplication.Repositories;
using MyApplication.Models;
using MyApplication.ViewModels;

namespace MyApplication.Pages.Activities
{
    public class IndexModel : PageModel
    {
        private readonly IActivityRepository _activityRepository;

        public List<Activity> Activities { get; set; } = new();

        public IndexModel(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
        }

        public void OnGet()
        {
            Activities = _activityRepository.Get();
        }
    }
}
