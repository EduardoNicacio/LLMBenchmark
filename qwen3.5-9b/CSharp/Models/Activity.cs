using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace ActivityApp.Models
{
    /// <summary>
    /// Represents the Activity entity mapped to the [dbo].[Activity] table.
    /// </summary>
    public class Activity
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("ActivityId")]
        public Guid ActivityId { get; set; }

        [Required]
        [Column("ProjectId")]
        public Guid ProjectId { get; set; }

        [Required]
        [Column("ProjectMemberId")]
        public Guid ProjectMemberId { get; set; }

        [Required]
        [MaxLength(128)]
        [Column("Name")]
        public string Name { get; set; } = string.Empty;

        [Required]
        [MaxLength(4000)]
        [Column("Description")]
        public string Description { get; set; } = string.Empty;

        [Column("StartDate")]
        public DateTime? StartDate { get; set; }

        [Column("TargetDate")]
        public DateTime? TargetDate { get; set; }

        [Column("EndDate")]
        public DateTime? EndDate { get; set; }

        [Column("ProgressStatus")]
        public byte? ProgressStatus { get; set; }

        [Column("ActivityPoints")]
        public short? ActivityPoints { get; set; }

        [Column("Priority")]
        public byte? Priority { get; set; }

        [Column("Risk")]
        public byte? Risk { get; set; }

        [MaxLength(200)]
        [Column("Tags")]
        public string? Tags { get; set; }

        [Required]
        [Column("ActiveFlag")]
        public bool ActiveFlag { get; set; }

        [Required]
        [Column("SystemDeleteFlag")]
        public bool SystemDeleteFlag { get; set; }

        [Required]
        [Column("CreatedDateTime")]
        public DateTime CreatedDateTime { get; set; }

        [Required]
        [Column("CreatedByUser")]
        public string CreatedByUser { get; set; } = string.Empty;

        [Required]
        [Column("CreatedByProgram")]
        public string CreatedByProgram { get; set; } = string.Empty;

        [Column("UpdatedDateTime")]
        public DateTime? UpdatedDateTime { get; set; }

        [Column("UpdatedByUser")]
        public string? UpdatedByUser { get; set; }

        [Column("UpdatedByProgram")]
        public string? UpdatedByProgram { get; set; }

        [Column("SystemTimestamp")]
        public byte[]? SystemTimestamp { get; set; }
    }
}