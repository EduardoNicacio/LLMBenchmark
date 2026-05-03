using System.Collections.Generic;

namespace YourApp.Web.ViewModels
{
    /// <summary>
    /// View model used by the Edit Razor Page.
    /// </summary>
    public class ActivityUpdateViewModel
    {
        [Required] public Guid ActivityId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? ProjectMemberId { get; set; }

        [MaxLength(128)] public string? Name { get; set; }
        [MaxLength(4000)] public string? Description { get; set; }
        public DateOnly? StartDate { get; set; }
        public DateOnly? TargetDate { get; set; }
        public DateOnly? EndDate { get; set; }

        public IReadOnlyList<string> ProgressStatusItems => new List<string> { "0", "1" };
        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }
        public IReadOnlyList<string> PriorityItems => new List<string> { "Low", "Medium", "High" };
        public byte? Priority { get; set; }

        public IReadOnlyList<string> RiskItems => new List<string> { "None", "Medium", "High" };
        public byte? Risk { get; set; }

        [MaxLength(200)] public string? Tags { get; set; }
        public byte? ActiveFlag { get; set; }

        // Concurrency token – hidden in the form
        [Required] public byte[] SystemTimestamp { get; set; } = null!;
    }
}
