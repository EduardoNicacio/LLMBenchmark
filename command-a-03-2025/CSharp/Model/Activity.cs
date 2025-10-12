using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ActivityTracker.Models
{
    public class Activity
    {
        [Key]
        public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
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
        public byte ActiveFlag { get; set; }
        [Required]
        [StringLength(1)]
        public string SystemDeleteFlag { get; set; }
        public DateTime CreatedDateTime { get; set; }
        [Required]
        [StringLength(100)]
        public string CreatedByUser { get; set; }
        [Required]
        [StringLength(100)]
        public string CreatedByProgram { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        [StringLength(100)]
        public string UpdatedByUser { get; set; }
        [StringLength(100)]
        public string UpdatedByProgram { get; set; }
        [Timestamp]
        public byte[] SystemTimestamp { get; set; }
    }
}
