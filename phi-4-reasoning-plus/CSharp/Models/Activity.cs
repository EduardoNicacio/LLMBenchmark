using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.Models
{
    // C# Model representing the Activity table.
    public class Activity
    {
        [Key]
        public Guid ActivityId { get; set; }

        // Required foreign key columns.
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        public string Name { get; set; }

        [Required, MaxLength(4000)]
        public string Description { get; set; }

        // Nullable date columns.
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        // Tinyint mapped as unsigned byte (nullable).
        public byte? ProgressStatus { get; set; }

        // smallint mapped to int.
        public int? ActivityPoints { get; set; }

        public byte? Priority { get; set; }
        public byte? Risk { get; set; }

        [MaxLength(200)]
        public string Tags { get; set; }

        // ActiveFlag as boolean (0/1 in SQL).
        [Required]
        public bool ActiveFlag { get; set; }

        // SystemDeleteFlag stored as a single character.
        [Required, RegularExpression("^[YN]$", ErrorMessage = "SystemDeleteFlag must be 'Y' or 'N'.")]
        public string SystemDeleteFlag { get; set; }

        // Creation timestamps and user info.
        [Required]
        public DateTime CreatedDateTime { get; set; }

        [Required, MaxLength(100)]
        public string CreatedByUser { get; set; }

        [Required, MaxLength(100)]
        public string CreatedByProgram { get; set; }

        // Optional update info.
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }
        public string UpdatedByProgram { get; set; }

        // Concurrency token mapped to the timestamp column.
        [Timestamp]
        public byte[] SystemTimestamp { get; set; }
    }
}