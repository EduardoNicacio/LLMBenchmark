using System;
using System.ComponentModel.DataAnnotations;

namespace ProjectManagement.Dtos
{
    public class ActivityCreateDto
    {
        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [StringLength(128)]
        public string Name { get; set; } = string.Empty;

        [Required]
        [StringLength(4000)]
        public string Description { get; set; } = string.Empty;

        [Column(TypeName = "date")]
        public DateTime? StartDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? TargetDate { get; set; }

        [Range(0, 100)]
        public byte? ProgressStatus { get; set; }

        [Range(0, 32767)]
        public short? ActivityPoints { get; set; }

        [Range(0, 5)]
        public byte? Priority { get; set; }

        [Range(0, 10)]
        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; } = string.Empty;

        public bool ActiveFlag { get; set; } = true;
    }
}
