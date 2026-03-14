using System.ComponentModel.DataAnnotations;

namespace ActivityApp.ViewModels
{
    /// <summary>
    /// ViewModel for creating a new Activity in Razor Pages.
    /// </summary>
    public class ActivityCreateViewModel
    {
        [Required]
        [MaxLength(128)]
        public string Name { get; set; } = string.Empty;

        [Required]
        [MaxLength(4000)]
        public string Description { get; set; } = string.Empty;

        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string? Tags { get; set; }
    }

    /// <summary>
    /// ViewModel for editing an existing Activity.
    /// </summary>
    public class ActivityEditViewModel
    {
        public Guid ActivityId { get; set; }

        [Required]
        [MaxLength(128)]
        public string Name { get; set; } = string.Empty;

        [Required]
        [MaxLength(4000)]
        public string Description { get; set; } = string.Empty;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string? Tags { get; set; }
        public bool ActiveFlag { get; set; }
    }

    /// <summary>
    /// ViewModel for listing Activities.
    /// </summary>
    public class ActivityListViewModel
    {
        public ActivityDto Activity { get; set; } = new();
        public string? ErrorMessage { get; set; }
    }
}
