using System;
using System.ComponentModel.DataAnnotations;

namespace ActivityTracker.DTOs
{
    public class CreateActivityDto
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
        public byte ActiveFlag { get; set; }
        [Required]
        [StringLength(1)]
        public string SystemDeleteFlag { get; set; }
        [Required]
        public DateTime CreatedDateTime { get; set; }
        [Required]
        [StringLength(100)]
        public string CreatedByUser { get; set; }
        [Required]
        [StringLength(100)]
        public string CreatedByProgram { get; set; }
    }

    public class UpdateActivityDto
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
        public byte ActiveFlag { get; set; }
        [StringLength(1)]
        public string SystemDeleteFlag { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        [StringLength(100)]
        public string UpdatedByUser { get; set; }
        [StringLength(100)]
        public string UpdatedByProgram { get; set; }
    }

    public class ReadActivityDto
    {
        public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string Tags { get; set; }
        public byte ActiveFlag { get; set; }
        public string SystemDeleteFlag { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUser { get; set; }
        public string CreatedByProgram { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }
        public string UpdatedByProgram { get; set; }
    }
}
