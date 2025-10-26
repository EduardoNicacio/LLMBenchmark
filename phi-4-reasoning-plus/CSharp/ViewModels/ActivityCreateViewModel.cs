using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.ViewModels
{
    // Razor Page model for creating an Activity.
    public class ActivityCreateViewModel
    {
        [Required]
        [Display(Name = "Project ID")]
        public Guid ProjectId { get; set; }

        [Required]
        [Display(Name = "Member ID")]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        [Display(Name = "Activity Name")]
        public string Name { get; set; }

        [Required, MaxLength(4000)]
        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Target Date")]
        public DateTime? TargetDate { get; set; }

        [Display(Name = "End Date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Progress Status")]
        public byte? ProgressStatus { get; set; }

        [Display(Name = "Activity Points")]
        public int? ActivityPoints { get; set; }

        [Display(Name = "Priority")]
        public byte? Priority { get; set; }

        [Display(Name = "Risk")]
        public byte? Risk { get; set; }

        [MaxLength(200)]
        [Display(Name = "Tags")]
        public string Tags { get; set; }

        [Required]
        [Display(Name = "Active Flag")]
        public bool ActiveFlag { get; set; }

        [Required, RegularExpression("^[YN]$", ErrorMessage = "SystemDeleteFlag must be 'Y' or 'N'.")]
        [Display(Name = "System Delete Flag")]
        public string SystemDeleteFlag { get; set; } = "N";
    }
}