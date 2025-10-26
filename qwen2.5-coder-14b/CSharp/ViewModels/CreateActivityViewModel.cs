namespace ActivityManagement.ViewModels
{
    public class CreateActivityViewModel
    {
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        public string Name { get; set; } = null!;

        [Required, MaxLength(4000)]
        public string Description { get; set; } = null!;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }

        public byte ProgressStatus { get; set; }
        public short ActivityPoints { get; set; }
        public byte Priority { get; set; }
        public byte Risk { get; set; }

        [MaxLength(200)]
        public string Tags { get; set; } = null!;

        [Required]
        public byte ActiveFlag { get; set; }

        [Required, MaxLength(1)]
        public char SystemDeleteFlag { get; set; }
    }
}
