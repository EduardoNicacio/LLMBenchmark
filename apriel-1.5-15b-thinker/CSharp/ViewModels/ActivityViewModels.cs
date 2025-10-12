// Models/ViewModels/ActivityCreateViewModel.cs
using System.ComponentModel.DataAnnotations;

namespace MyApp.Models.ViewModels
{
    public class ActivityCreateViewModel
    {
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        [Display(Name = "Name")]
        public string Name { get; set; } = null!;

        [Required, MaxLength(4000)]
        [Display(Name = "Description")]
        public string Description { get; set; } = null!;

        [AllowNullable]
        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        [AllowNullable]
        [Display(Name = "Target Date")]
        public DateTime? TargetDate { get; set; }

        [AllowNullable]
        [Display(Name = "End Date")]
        public DateTime? EndDate { get; set; }

        [AllowNullable]
        [Display(Name = "Progress Status")]
        public short? ProgressStatus { get; set; }

        [AllowNullable]
        [Display(Name = "Activity Points")]
        public short? ActivityPoints { get; set; }

        [AllowNullable]
        [Display(Name = "Priority")]
        public short? Priority { get; set; }

        [AllowNullable]
        [Display(Name = "Risk")]
        public short? Risk { get; set; }

        [AllowNullable]
        [Display(Name = "Tags (max 200 chars)")]
        public string Tags { get; set; } = null!;

        // System columns – hidden from UI but still validated
        [Required]               // ActiveFlag is mandatory by DB schema
        public short ActiveFlag { get; set; }

        [Default('N')]
        public char SystemDeleteFlag { get; set; }
    }
}

// Models/ViewModels/ActivityUpdateViewModel.cs
namespace MyApp.Models.ViewModels
{
    public class ActivityUpdateViewModel
    {
        public Guid ActivityId { get; set; }

        // Same fields as Create but nullable to allow partial updates
        [AllowNullable]
        [Display(Name = "Name")]
        public string? Name { get; set; }

        [AllowNullable]
        [Display(Name = "Description")]
        public string? Description { get; set; }

        [AllowNullable]
        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }

        [AllowNullable]
        [Display(Name = "Target Date")]
        public DateTime? TargetDate { get; set; }

        [AllowNullable]
        [Display(Name = "End Date")]
        public DateTime? EndDate { get; set; }

        [AllowNullable]
        [Display(Name = "Progress Status")]
        public short? ProgressStatus { get; set; }

        [AllowNullable]
        [Display(Name = "Activity Points")]
        public short? ActivityPoints { get; set; }

        [AllowNullable]
        [Display(Name = "Priority")]
        public short? Priority { get; set; }

        [AllowNullable]
        [Display(Name = "Risk")]
        public short? Risk { get; set; }

        [AllowNullable]
        [Display(Name = "Tags (max 200 chars)")]
        public string Tags { get; set; } = null!;

        // Soft‑delete flag can be toggled
        [AllowNullable]
        public char? SystemDeleteFlag { get; set; }

        // ActiveFlag rarely changes but exposed for completeness
        [AllowNullable]
        public short? ActiveFlag { get; set; }
    }
}

// Models/ViewModels/ActivityListViewModel.cs
namespace MyApp.Models.ViewModels
{
    using System.Collections.Generic;

    public class ActivityListViewModel
    {
        public List<ActivityReadDto> Activities { get; set; } = new();

        public int PageNumber { get; set; } = 1;
        public const int PageSize = 20; // configurable

        public IReadOnlyList<Activity>? SelectedActivity { get; set; }
    }
}
