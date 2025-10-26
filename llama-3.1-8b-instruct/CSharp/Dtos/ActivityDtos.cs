// Dtos/ActivityDtos.cs

namespace YourNamespace.Dtos
{
    public class CreateDto
    {
        [Required]
        public Guid ProjectId { get; set; }
        [Required]
        public Guid ProjectMemberId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte ProgressStatus { get; set; }
        public short ActivityPoints { get; set; }
        [Range(1, 5)]
        public byte Priority { get; set; }
        [Range(1, 5)]
        public byte Risk { get; set; }
        [MaxLength(200)]
        public string Tags { get; set; }
    }

    public class UpdateDto
    {
        [Required]
        public Guid ProjectId { get; set; }
        [Required]
        public Guid ProjectMemberId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte ProgressStatus { get; set; }
        public short ActivityPoints { get; set; }
        [Range(1, 5)]
        public byte Priority { get; set; }
        [Range(1, 5)]
        public byte Risk { get; set; }
        [MaxLength(200)]
        public string Tags { get; set; }
    }

    public class ReadDto
    {
        public Guid ActivityId { get; set; }
        public Guid ProjectId { get; set; }
        public Guid ProjectMemberId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }
        public byte ProgressStatus { get; set; }
        public short ActivityPoints { get; set; }
        [Range(1, 5)]
        public byte Priority { get; set; }
        [Range(1, 5)]
        public byte Risk { get; set; }
        [MaxLength(200)]
        public string Tags { get; set; }
    }
}
