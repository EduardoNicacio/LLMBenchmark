// src/Entities/Activity.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace MyApp.Data.Entities;

public class Activity
{
    // Primary key (GUID)
    [Required, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public Guid ActivityId { get; set; }

    // Foreign keys
    [Required]
    public Guid ProjectId { get; set; }

    [Required]
    public Guid ProjectMemberId { get; set; }

    // Core fields
    [Required, MaxLength(128)]
    public string Name { get; set; } = null!;

    [Required, MaxLength(4000)]
    public string Description { get; set; } = null!;

    public DateTime? StartDate { get; set; }

    public DateTime? TargetDate { get; set; }

    public DateTime? EndDate { get; set; }

    [ColumnType("tinyint")]
    public short? ProgressStatus { get; set; }

    [ColumnType("smallint")]
    public short? ActivityPoints { get; set; }

    [ColumnType("tinyint")]
    public short? Priority { get; set; }

    [ColumnType("tinyint")]
    public short? Risk { get; set; }

    [ColumnType("nvarchar", "200")]
    public string? Tags { get; set; }

    // Soft delete flags
    [Required]
    [ColumnType("tinyint")]
    public short ActiveFlag { get; set; } = 1;

    [Required, ColumnType("char", "1")]
    public char SystemDeleteFlag { get; set; } = 'N';

    // Auditing fields
    [Required, ColumnType("datetime2", "7")]
    public DateTime CreatedDateTime { get; set; }

    [Required, MaxLength(100)]
    public string CreatedByUser { get; set; } = null!;

    [Required, MaxLength(100)]
    public string CreatedByProgram { get; set; } = null!;

    public DateTime? UpdatedDateTime { get; set; }

    public string? UpdatedByUser { get; set; }

    public string? UpdatedByProgram { get; set; }

    [ColumnType("timestamp")]
    public byte[] SystemTimestamp { get; set; } = Array.Empty<byte>();

    // EF Core navigation properties can be added here if needed.
}
