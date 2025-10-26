namespace ActivityManagement.ViewModels
{
    public class ListActivityViewModel
    {
        public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }

        [MaxLength(128)]
        public string Name { get; set; } = null!;

        [MaxLength(4000)]
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

        public byte ActiveFlag { get; set; }

        [MaxLength(1)]
        public char SystemDeleteFlag { get; set; }

        public DateTime CreatedDateTime { get; set; }
    }
}
