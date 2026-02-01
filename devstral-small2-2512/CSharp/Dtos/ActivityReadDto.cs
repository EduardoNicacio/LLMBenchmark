using System;
using System.ComponentModel.DataAnnotations;

namespace ProjectManagement.Dtos
{
    public class ActivityReadDto
    {
        public Guid ActivityId { get; set; }

        public Guid ProjectId { get; set; }

        public Guid ProjectMemberId { get; set; }

        public string Name { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        [Column(TypeName = "date")]
        public DateTime? StartDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? TargetDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }

        public short? ActivityPoints { get; set; }

        public byte? Priority { get; set; }

        public byte? Risk { get; set; }

        public string Tags { get; set; } = string.Empty;

        public bool ActiveFlag { get; set; }

        public DateTime CreatedDateTime { get; set; }

        public string CreatedByUser { get; set; } = string.Empty;

        public DateTime? UpdatedDateTime { get; set; }

        public string UpdatedByUser { get; set; }
    }
}
