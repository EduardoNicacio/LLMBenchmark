// UpdateActivityDto.cs - For updating existing activities
using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;

namespace YourApp.DTOs

{
    public class UpdateActivityDto
    {
        [Required]
        public Guid ActivityId { get; set; }

        [Required]
        public Guid ProjectId { get; set; }
        
        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; } = null!;

        [Required]
        [StringLength(4000)]
        public string Description { get; set; } = null!;

        public DateOnly? StartDate { get; set; }
        public DateOnly? TargetDate { get; set; }
        public DateOnly? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; }

        [Required]
        public bool ActiveFlag { get; set; } = true;

        [Required]
        [StringLength(1)] // char(1)
        public string SystemDeleteFlag { get; set; } = "N";

        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }

        public string UpdatedByProgram { get; set; }
    }
}
