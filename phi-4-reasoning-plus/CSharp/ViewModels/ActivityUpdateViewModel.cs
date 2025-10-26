using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.ViewModels
{
    // Razor Page model for updating an Activity.
    public class ActivityUpdateViewModel
    {
        [Required, MaxLength(128)]
        [Display(Name = "Activity Name")]
        public string Name { get; set; }

        [MaxLength(4000)]
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
        public string SystemDeleteFlag { get; set; }

        // Optional updated info.
        [Display(Name = "Updated Date Time")]
        public DateTime? UpdatedDateTime { get; set; }

        [MaxLength(100)]
        [Display(Name = "Updated By User")]
        public string UpdatedByUser { get; set; }

        [MaxLength(100)]
        [Display(Name = "Updated By Program")]
        public string UpdatedByProgram { get; set; }
    }
}