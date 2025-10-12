using System;
using System.ComponentModel.DataAnnotations;

namespace YourNamespace.Models
{
    public class Activity
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
        public byte ActiveFlag { get; set; }
        [Required]
        public char SystemDeleteFlag { get; set; }
        [Required]
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
        [Required]
        public byte[] SystemTimestamp { get; set; }
    }
}
