using System;

namespace MyApp.DTOs
{
    // DTO for updating an existing Activity.
    public class ActivityUpdateDto
    {
        [Required, MaxLength(128)]
        public string Name { get; set; }

        [MaxLength(4000)]
        public string Description { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }
        public int? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }

        [MaxLength(200)]
        public string Tags { get; set; }

        // Flags.
        public bool ActiveFlag { get; set; }
        public string SystemDeleteFlag { get; set; }

        // Optional update info.
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }
        public string UpdatedByProgram { get; set; }
    }
}