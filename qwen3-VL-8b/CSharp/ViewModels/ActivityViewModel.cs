// C# View Models: ActivityViewModel.cs
using System.ComponentModel.DataAnnotations;

namespace YourProject.ViewModels
{
    public class CreateActivityViewModel
    {
        [Required(ErrorMessage = "Project is required")]
        public Guid ProjectId { get; set; }

        [Required(ErrorMessage = "Project Member is required")]
        public Guid ProjectMemberId { get; set; }

        [Required(ErrorMessage = "Name is required")]
        [StringLength(128, ErrorMessage = "Name cannot exceed 128 characters")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "Description is required")]
        [StringLength(4000, ErrorMessage = "Description cannot exceed 4000 characters")]
        public string Description { get; set; } = string.Empty;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string? Tags { get; set; }
    }

    public class UpdateActivityViewModel
    {
        [Required(ErrorMessage = "Project is required")]
        public Guid ProjectId { get; set; }

        [Required(ErrorMessage = "Project Member is required")]
        public Guid ProjectMemberId { get; set; }

        [StringLength(128, ErrorMessage = "Name cannot exceed 128 characters")]
        public string? Name { get; set; }

        [StringLength(4000, ErrorMessage = "Description cannot exceed 4000 characters")]
        public string? Description { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string? Tags { get; set; }
    }

    public class ListActivityViewModel
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string ProjectName { get; set; } = string.Empty; // Assuming you’ll join with Project table
        public string ProjectMemberName { get; set; } = string.Empty; // Assuming you’ll join with ProjectMember table
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string Tags { get; set; } = string.Empty;
        public byte ActiveFlag { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUser { get; set; } = string.Empty;
        public DateTime? UpdatedDateTime { get; set; }
        public string? UpdatedByUser { get; set; }
    }
}
