using System;
using System.ComponentModel.DataAnnotations;

namespace YourNamespace.Models
{
    public class Activity
    {
        [Key]
        [Required]
        [Guid]
        public Guid ActivityId { get; set; }

        [Required]
        [Guid]
        public Guid ProjectId { get; set; }

        [Required]
        [Guid]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; } = null!;

        [Required]
        [StringLength(4000)]
        public string Description { get; set; } = null!;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }

        [StringLength(200)]
        public string? Tags { get; set; }

        [Required]
        [Range(0, 255)] // Tinyint range (0-255)
        public byte ActiveFlag { get; set; } // ActiveFlag (1 = active, 0 = inactive)

        [Required]
        [StringLength(1)]
        public char SystemDeleteFlag { get; set; } // 'Y' = deleted, 'N' = active

        [Required]
        public DateTime CreatedDateTime { get; set; }

        [Required]
        [StringLength(100)]
        public string CreatedByUser { get; set; } = null!;

        [Required]
        [StringLength(100)]
        public string CreatedByProgram { get; set; } = null!;

        public DateTime? UpdatedDateTime { get; set; }
        public string? UpdatedByUser { get; set; }
        public string? UpdatedByProgram { get; set; }

        [Required]
        [Column("SystemTimestamp")]
        public byte[] SystemTimestamp { get; set; } = null!; // Timestamp (row version)
    }
}
