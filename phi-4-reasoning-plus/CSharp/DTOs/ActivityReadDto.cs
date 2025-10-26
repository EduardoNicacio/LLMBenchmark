using System;

namespace MyApp.DTOs
{
    // DTO for reading and returning Activity data.
    public class ActivityReadDto
    {
        public Guid ActivityId { get; set; }

        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }

        [MaxLength(128)]
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

        public bool ActiveFlag { get; set; }
        public string SystemDeleteFlag { get; set; }

        public DateTime CreatedDateTime { get; set; }
        [MaxLength(100)]
        public string CreatedByUser { get; set; }
        [MaxLength(100)]
        public string CreatedByProgram { get; set; }

        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }
        public string UpdatedByProgram { get; set; }
    }
}