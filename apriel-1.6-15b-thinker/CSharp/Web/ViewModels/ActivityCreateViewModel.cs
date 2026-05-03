using System.Collections.Generic;

namespace YourApp.Web.ViewModels
{
    /// <summary>
    /// View model used by the Create Razor Page.
    /// </summary>
    public class ActivityCreateViewModel
    {
        [Required] public Guid ProjectId { get; set; }
        [Required] public Guid ProjectMemberId { get; set; }
        [Required, MaxLength(128)] public string Name { get; set; } = default!;
        [Required, MaxLength(4000)] public string Description { get; set; } = default!;
        public DateOnly? StartDate { get; set; }
        public DateOnly? TargetDate { get; set; }
        public DateOnly? EndDate { get; set; }

        // Select‑list options – static for demo purposes
        public IReadOnlyList<string> ProgressStatusItems => new List<string> { "0", "1" };
        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }
        public IReadOnlyList<string> PriorityItems => new List<string> { "Low", "Medium", "High" };
        public byte? Priority { get; set; }

        public IReadOnlyList<string> RiskItems => new List<string> { "None", "Medium", "High" };
        public byte? Risk { get; set; }

        [MaxLength(200)] public string? Tags { get; set; }
        [Required] public byte ActiveFlag { get; set; } = 1;
    }
}
