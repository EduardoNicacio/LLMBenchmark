// Models/Activity.cs
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyApp.Models
{
    // Base class for all entities (Guid PK + created/updated timestamps)
    public abstract class AppEntity
    {
        [Key]
        [Column("Id", TypeName = "uniqueidentifier")]
        public override Guid Id { get; set; } = Guid.NewGuid();

        [Column("CreatedDateTime", TypeName = "datetime2(7)")]
        public DateTime CreatedDateTime { get; set; }

        [AllowNullable]
        [Column("UpdatedDateTime", TypeName = "datetime2(7)")]
        public DateTime? UpdatedDateTime { get; set; }
    }

    // Main entity – mirrors dbo.Activity exactly
    [Table("dbo.Activity")]
    public class Activity : AppEntity
    {
        // Business columns ----------------------------------------------------
        [Required]
        [Column("ProjectId", TypeName = "uniqueidentifier")]
        public Guid ProjectId { get; set; }

        [Required]
        [Column("ProjectMemberId", TypeName = "uniqueidentifier")]
        public Guid ProjectMemberId { get; set; }

        [Required, MaxLength(128)]
        [Column("Name", TypeName = "nvarchar(128)")]
        public string Name { get; set; } = null!;

        [Required, MaxLength(4000)]
        [Column("Description", TypeName = "nvarchar(4000)")]
        public string Description { get; set; } = null!;

        [AllowNullable]
        [Column("StartDate", TypeName = "date")]
        public DateTime? StartDate { get; set; }

        [AllowNullable]
        [Column("TargetDate", TypeName = "date")]
        public DateTime? TargetDate { get; set; }

        [AllowNullable]
        [Column("EndDate", TypeName = "date")]
        public DateTime? EndDate { get; set; }

        [AllowNullable]
        [Column("ProgressStatus", TypeName = "tinyint")]
        public short? ProgressStatus { get; set; }

        [AllowNullable]
        [Column("ActivityPoints", TypeName = "smallint")]
        public short? ActivityPoints { get; set; }

        [AllowNullable]
        [Column("Priority", TypeName = "tinyint")]
        public short? Priority { get; set; }

        [AllowNullable]
        [Column("Risk", TypeName = "tinyint")]
        public short? Risk { get; set; }

        [AllowNullable]
        [Column("Tags", TypeName = "nvarchar(200)")]
        public string Tags { get; set; } = null!;

        // System columns -------------------------------------------------------
        [Required]
        [Column("ActiveFlag", TypeName = "tinyint")]
        public short ActiveFlag { get; set; }

        [Required]
        [Column("SystemDeleteFlag", TypeName = "char(1)")]
        public char SystemDeleteFlag { get; set; } = 'N';

        // Additional audit columns ---------------------------------------------
        [AllowNullable]
        [Column("UpdatedByUser", TypeName = "nvarchar(100)")]
        public string? UpdatedByUser { get; set; }

        [AllowNullable]
        [Column("UpdatedByProgram", TypeName = "nvarchar(100)")]
        public string? UpdatedByProgram { get; set; }

        // Timestamp (binary) – EF Core will map automatically
        [Column("SystemTimestamp", TypeName = "timestamp")]
        public byte[] SystemTimestamp { get; set; }

        // Navigation properties (optional, for readability)
        public virtual Project? Project { get; set; }
        public virtual ApplicationUser? ProjectMember { get; set; }
    }
}
