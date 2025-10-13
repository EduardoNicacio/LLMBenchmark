using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ActivityManagement.ViewModels
{
    // Create View Model
    public class CreateActivityViewModel
    {
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; }

        [Required]
        [StringLength(4000)]
        public string Description { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? TargetDate { get; set; }

        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }

        public byte? Priority { get; set; }

        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; }

        [Required]
        public bool ActiveFlag { get; set; }
    }

    // Update View Model
    public class UpdateActivityViewModel
    {
        [Required]
        public Guid ActivityId { get; set; }

        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; }

        [Required]
        [StringLength(4000)]
        public string Description { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? TargetDate { get; set; }

        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }

        public byte? Priority { get; set; }

        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; }

        [Required]
        public bool ActiveFlag { get; set; }
    }

    // List View Model
    public class ActivityListViewModel
    {
        public IEnumerable<ReadActivityDto> Activities { get; set; }
    }

    // Details View Model
    public class ActivityDetailsViewModel
    {
        public ReadActivityDto Activity { get; set; }
    }
}
