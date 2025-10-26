using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.DTOs
{
    // DTO for creating a new Activity.
    public class ActivityCreateDto
    {
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        public string Name { get; set; }

        [Required, MaxLength(4000)]
        public string Description { get; set; }

        // Nullable date fields.
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        // Numeric values.
        public byte? ProgressStatus { get; set; }
        public int? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }

        [MaxLength(200)]
        public string Tags { get; set; }

        // Flags.
        public bool ActiveFlag { get; set; }
        // Defaulting to "N" (not deleted) if not provided.
        public string SystemDeleteFlag { get; set; } = "N";

        // Creation information – could be auto-populated in production.
        public DateTime CreatedDateTime { get; set; }

        [MaxLength(100)]
        public string CreatedByUser { get; set; }

        [MaxLength(100)]
        public string CreatedByProgram { get; set; }
    }
}