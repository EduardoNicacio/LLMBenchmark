using System;
using System.ComponentModel.DataAnnotations;

namespace YourNamespace.Models
{
    public class Activity
    {
        [Key]
        public Guid ActivityId { get; set; }
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
        public char SystemDeleteFlag { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUser { get; set; }
        public string CreatedByProgram { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }
        public string UpdatedByProgram { get; set; }
        public byte[] SystemTimestamp { get; set; }
    }
}
