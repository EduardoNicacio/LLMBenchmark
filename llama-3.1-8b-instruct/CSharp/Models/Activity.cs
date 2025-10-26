// Models/Activity.cs

namespace YourNamespace.Models
{
    public class Activity
    {
        public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }
        [Required]
        [MaxLength(128)]
        public string Name { get; set; }
        [Required]
        [MaxLength(4000)]
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte Priority { get; set; }
        public byte Risk { get; set; }
        [MaxLength(200)]
        public string Tags { get; set; }
        [Required]
        public byte ActiveFlag { get; set; }
        [Required]
        public char SystemDeleteFlag { get; set; }
        [Required]
        public DateTime CreatedDateTime { get; set; }
        [Required]
        public string CreatedByUser { get; set; }
        [Required]
        public string CreatedByProgram { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }
        public string UpdatedByProgram { get; set; }
        [Timestamp]
        public byte[] SystemTimestamp { get; set; }

        public Activity()
        {
            CreatedDateTime = DateTime.UtcNow;
            CreatedByUser = "System";
            CreatedByProgram = "System";
            ActiveFlag = 1;
            SystemDeleteFlag = 'N';
            SystemTimestamp = new byte[8];
        }
    }
}
