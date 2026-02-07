// Activity.cs - Represents the Activity table entity
using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;

namespace YourApp.Models // Replace with your actual namespace

{
    public class Activity
    {
        [Key] // EF Core primary key annotation
        public Guid ActivityId { get; set; } = Guid.NewGuid(); // Auto-generate on creation
        
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

        public byte? ProgressStatus { get; set; } // tinyint -> byte
        public short? ActivityPoints { get; set; } // smallint -> short
        public byte? Priority { get; set; } // tinyint
        public byte? Risk { get; set; } // tinyint

        [StringLength(200)]
        public string Tags { get; set; }

        [Required]
        public bool ActiveFlag { get; set; } = true;

        [Required]
        [StringLength(1)] // char(1) in SQL
        public string SystemDeleteFlag { get; set; } = "N"; 

        [Required]
        public DateTime CreatedDateTime { get; set; }

        [Required]
        [StringLength(100)]
        public string CreatedByUser { get; set; } = null!;

        [Required]
        [StringLength(100)]
        public string CreatedByProgram { get; set; } = null!;
        
        public DateTime? UpdatedDateTime { get; set; }
        public string UpdatedByUser { get; set; }

        public string UpdatedByProgram { get; set; }

        // RowVersion for SQL timestamp
        public byte[] SystemTimestamp { get; set; } = Array.Empty<byte>();
    }
}
