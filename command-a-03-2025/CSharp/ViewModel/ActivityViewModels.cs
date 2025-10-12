using System;
using System.ComponentModel.DataAnnotations;

namespace ActivityTracker.ViewModels
{
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
    }

    public class UpdateActivityViewModel
    {
        [Required]
        public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }
        [StringLength(128)]
        public string Name { get; set; }
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
    }

    public class ListActivityViewModel
    {
        public Guid ActivityId { get; set; }
        public string Name { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
    }
}
