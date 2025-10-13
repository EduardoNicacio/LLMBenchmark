// src/Dtos/ReadActivityDto.cs
using System;

namespace MyApp.Data.Dtos;

public class ReadActivityDto
{
    public Guid ActivityId { get; set; }

    public Guid ProjectId { get; set; }

    public Guid ProjectMemberId { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public DateTime? StartDate { get; set; }

    public DateTime? TargetDate { get; set; }

    public DateTime? EndDate { get; set; }

    public short? ProgressStatus { get; set; }

    public short? ActivityPoints { get; set; }

    public short? Priority { get; set; }

    public short? Risk { get; set; }

    public string Tags { get; set; } = null!;

    public short ActiveFlag { get; set; }

    public char SystemDeleteFlag { get; set; }

    public DateTime CreatedDateTime { get; set; }

    public string CreatedByUser { get; set; } = null!;

    public string CreatedByProgram { get; set; } = null!;

    public DateTime? UpdatedDateTime { get; set; }

    public string UpdatedByUser { get; set; } = null!;

    public string UpdatedByProgram { get; set; } = null!;

    public byte[] SystemTimestamp { get; set; } = Array.Empty<byte>();
}
