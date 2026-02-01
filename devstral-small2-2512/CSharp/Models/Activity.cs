using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjectManagement.Models
{
    public class Activity
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid ActivityId { get; set; }

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

        [Column(TypeName = "date")]
        public DateTime? EndDate { get; set; }

        [Range(0, 100)]
        public byte? ProgressStatus { get; set; }

        [Range(0, 32767)]
        public short? ActivityPoints { get; set; }

        [Range(0, 5)] // Assuming priority is 0-5
        public byte? Priority { get; set; }

        [Range(0, 10)] // Assuming risk is 0-10
        public byte? Risk { get; set; }

        [StringLength(200)]
        public string Tags { get; set; } = string.Empty;

        [Required]
        public bool ActiveFlag { get; set; }

        [Required]
        [StringLength(1)]
        public string SystemDeleteFlag { get; set; } = "N";

        [Required]
        public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;

        [Required]
        [StringLength(100)]
        public string CreatedByUser { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string CreatedByProgram { get; set; } = "WebApp";

        public DateTime? UpdatedDateTime { get; set; }

        [StringLength(100)]
        public string UpdatedByUser { get; set; }

        [StringLength(100)]
        public string UpdatedByProgram { get; set; }

        [Timestamp]
        public byte[] SystemTimestamp { get; set; }
    }
}
