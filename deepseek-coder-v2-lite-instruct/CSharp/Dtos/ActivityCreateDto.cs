using System;

namespace YourNamespace.DTOs
{
    public class ActivityCreateDto
    {
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
    }
}
