// C# View Models (ActivityViewModel.cs)
using System;
using System.ComponentModel.DataAnnotations;

namespace MyApplication.ViewModels
{
    public class ActivityCreateViewModel
    {
        [Required(ErrorMessage = "Project ID is required.")]
        public Guid ProjectId { get; set; }
        [Required(ErrorMessage = "Project Member ID is required.")]
        public Guid ProjectMemberId { get; set; }

        [Required(ErrorMessage = "Name is required.")]
        [StringLength(128, ErrorMessage = "Name cannot exceed 128 characters.")]
        public string Name { get; set; } = "";

        [StringLength(4000, ErrorMessage = "Description cannot exceed 4000 characters.")]
        public string Description { get; set; } = "";

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string Tags { get; set; } = "";
        public byte ActiveFlag { get; set; }
        public string CreatedByUser { get; set; } = "";
        public string CreatedByProgram { get; set; } = "";
    }

    public class ActivityUpdateViewModel
    {
        [Required(ErrorMessage = "Activity ID is required.")]
        public Guid ActivityId { get; set; }

        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string Tags { get; set; } = "";

        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; } = "";
        public string UpdatedByProgram { get; set; } = "";
    }

    public class ActivityListViewModel
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; } = "";
        // Add other relevant properties for the list view.
    }

    public class ActivityDetailsViewModel
    {
         public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }
        public string Name { get; set; } = "";
        public string Description { get; set; } = "";
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string Tags { get; set; } = "";
        public byte ActiveFlag { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUser { get; set; } = "";
        public string CreatedByProgram { get; set; } = "";
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; } = "";
        public string UpdatedByProgram { get; set; } = "";

    }
}
