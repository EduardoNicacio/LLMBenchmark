using System;
using System.Collections.Generic;

namespace ProjectManagement.ViewModels
{
    public class ActivityListViewModel
    {
        public List<ActivitySummaryViewModel> Activities { get; set; } = new List<ActivitySummaryViewModel>();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
    }

    public class ActivitySummaryViewModel
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public bool ActiveFlag { get; set; }
    }
}
