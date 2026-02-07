// C# Model: Activity.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace YourProject.Models
{
    public class Activity
    {
        public Guid ActivityId { get; set; }

        [Required]
        public Guid ProjectId { get; set; }

        [Required]
        public Guid ProjectMemberId { get; set; }

        [Required, StringLength(128)]
        public string Name { get; set; } = string.Empty;

        [Required, StringLength(4000)]
        public string Description { get; set; } = string.Empty;

        public DateTime? StartDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? EndDate { get; set; }

        public byte? ProgressStatus { get; set; }
        public short? ActivityPoints { get; set; }
        public byte? Priority { get; set; }
        public byte? Risk { get; set; }
        public string? Tags { get; set; }
        public byte ActiveFlag { get; set; }
        public char SystemDeleteFlag { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUser { get; set; } = string.Empty;
        public string CreatedByProgram { get; set; } = string.Empty;
        public DateTime? UpdatedDateTime { get; set; }
        public string? UpdatedByUser { get; set; }
        public string? UpdatedByProgram { get; set; }
        public byte[] SystemTimestamp { get; set; } = Array.Empty<byte>();
    }
}
