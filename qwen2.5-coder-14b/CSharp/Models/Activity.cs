using System;
using System.ComponentModel.DataAnnotations;

namespace ActivityManagement.Models
{
    public class Activity
    {
        [Key]
        public Guid ActivityId { get; set; }

        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(4000)]
        public string Description { get; set; } = null!;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public byte ProgressStatus { get; set; }
        public short ActivityPoints { get; set; }
        public byte Priority { get; set; }
        public byte Risk { get; set; }

        [MaxLength(200)]
        public string Tags { get; set; } = null!;

        [Required]
        public byte ActiveFlag { get; set; }

        [Required, MaxLength(1)]
        public char SystemDeleteFlag { get; set; }

        [Required]
        public DateTime CreatedDateTime { get; set; }

        [Required, MaxLength(100)]
        public string CreatedByUser { get; set; } = null!;

        [Required, MaxLength(100)]
        public string CreatedByProgram { get; set; } = null!;

        public DateTime? UpdatedDateTime { get; set; }

        [MaxLength(100)]
        public string UpdatedByUser { get; set; } = null!;

        [MaxLength(100)]
        public string UpdatedByProgram { get; set; } = null!;

        [Timestamp]
        public byte[] SystemTimestamp { get; set; }
    }
}
