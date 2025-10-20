using System;
using System.ComponentModel.DataAnnotations;

namespace YourNamespace.Models.ViewModels
{
    public class CreateActivityViewModel
    {
        [Required]
        [StringLength(128, MinimumLength = 3)]
        [Display(Name = "Activity Name")]
        public string Name { get; set; } = null!;

        [Required]
        [StringLength(4000)]
        [Display(Name = "Description")]
        public string Description { get; set; } = null!;

        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Target Date")]
        public DateTime? TargetDate { get; set; }

        [Display(Name = "End Date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Progress Status")]
        public byte? ProgressStatus { get; set; }

        [Display(Name = "Activity Points")]
        public short? ActivityPoints { get; set; }

        [Display(Name = "Priority")]
        public byte? Priority { get; set; }

        [Display(Name = "Risk Level")]
        public byte? Risk { get; set; }

        [Display(Name = "Tags")]
        [StringLength(200)]
        public string? Tags { get; set; }

        [Display(Name = "Active Flag")]
        [Range(0, 1)]
        public byte ActiveFlag { get; set; } = 1;

        [Display(Name = "System Delete Flag")]
        [Required]
        [Range('N', 'Y')]
        public char SystemDeleteFlag { get; set; } = 'N';

        [Display(Name = "Created By")]
        public string CreatedByUser { get; set; } = null!;

        [Display(Name = "Created By Program")]
        public string CreatedByProgram { get; set; } = null!;

        [Display(Name = "Created DateTime")]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd HH:mm}")]
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;
    }

    public class UpdateActivityViewModel : CreateActivityViewModel
    {
        [Required]
        [Display(Name = "Activity ID")]
        public Guid ActivityId { get; set; }
    }

    public class ListActivityViewModel
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; } = null!;
        public string Description { get; set; } = null!;
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public string? Tags { get; set; }
        public string Status { get; set; } = "Active"; // Derived from ActiveFlag
    }
}
