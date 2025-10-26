using System;
using System.Collections.Generic;

namespace MyApp.ViewModels
{
    // A summary view model for listing activities.
    public class ActivitySummary
    {
        public Guid ActivityId { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        public DateTime CreatedDateTime { get; set; }
    }

    // Main list view model.
    public class ActivityListViewModel
    {
        public IEnumerable<ActivitySummary> Activities { get; set; } = new List<ActivitySummary>();
    }
}