namespace YourApp.Domain.Entities;

[Table("Activity", Schema = "dbo")]
public sealed class Activity
{
    [Key]
    [Column("ActivityId")]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public Guid ActivityId { get; set; } = Guid.NewGuid();

    [Column("ProjectId")]
    [Required]
    public Guid ProjectId { get; set; }

    [Column("ProjectMemberId")]
    [Required]
    public Guid ProjectMemberId { get; set; }

    [Column("Name")]
    [MaxLength(128)]
    [Required]
    public string Name { get; set; } = null!;

    [Column("Description")]
    [MaxLength(4000)]
    [Required]
    public string Description { get; set; } = null!;

    [Column("StartDate")]
    public DateOnly? StartDate { get; set; }

    [Column("TargetDate")]
    public DateOnly? TargetDate { get; set; }

    [Column("EndDate")]
    public DateOnly? EndDate { get; set; }

    [Column("ProgressStatus")]
    public byte? ProgressStatus { get; set; }

    [Column("ActivityPoints")]
    public short? ActivityPoints { get; set; }

    [Column("Priority")]
    public byte? Priority { get; set; }

    [Column("Risk")]
    public byte? Risk { get; set; }

    [Column("Tags")]
    [MaxLength(200)]
    public string? Tags { get; set; }

    [Column("ActiveFlag")]
    [Required]
    public byte ActiveFlag { get; set; } = 1;

    [Column("SystemDeleteFlag")]
    [MaxLength(1)]
    [Required]
    public string SystemDeleteFlag { get; set; } = "N";

    [Column("CreatedDateTime")]
    [Required]
    public DateTime CreatedDateTime { get; set; } = DateTime.UtcNow;

    [Column("CreatedByUser")]
    [MaxLength(100)]
    [Required]
    public string CreatedByUser { get; set; } = null!;

    [Column("CreatedByProgram")]
    [MaxLength(100)]
    [Required]
    public string CreatedByProgram { get; set; } = null!;

    [Column("UpdatedDateTime")]
    public DateTime? UpdatedDateTime { get; set; }

    [Column("UpdatedByUser")]
    [MaxLength(100)]
    public string? UpdatedByUser { get; set; }

    [Column("UpdatedByProgram")]
    [MaxLength(100)]
    public string? UpdatedByProgram { get; set; }

    [Timestamp]
    [Column("SystemTimestamp")]
    public byte[] SystemTimestamp { get; set; } = new byte[8];
}
