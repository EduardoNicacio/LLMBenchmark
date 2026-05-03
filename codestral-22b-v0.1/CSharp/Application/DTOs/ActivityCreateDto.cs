// ActivityCreateDto.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace YourApp.Application.DTOs;

public sealed record ActivityCreateDto(
    [Required]
    public Guid ProjectId { get; init; } = default!,

    [Required]
    [MaxLength(128)]
    public string Name { get; init; } = null!,

    [Required]
    [MaxLength(4000)]
    public string Description { get; init; } = null!,

    public DateOnly? StartDate { get; init; },

    public DateOnly? TargetDate { get; init; },

    public short? ActivityPoints { get; init; },

    [Range(0, byte.MaxValue)]
    public byte? ProgressStatus { get; init; },

    [Range(0, byte.MaxValue)]
    public byte? Priority { get; init; },

    [Range(0, byte.MaxValue)]
    public byte? Risk { get; init; },

    [MaxLength(200)]
    public string? Tags { get; init; } = null!,

    [Required]
    [MaxLength(100)]
    public string CreatedByUser { get; init; } = null!,

    [Required]
    [MaxLength(100)]
    public string CreatedByProgram { get; init; } = null!
);
