// ActivityUpdateDto.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace YourApp.Application.DTOs;

public sealed record ActivityUpdateDto(
    [Required]
    public Guid ActivityId { get; init; },

    [Required]
    public byte[] SystemTimestamp { get; init; } = null!,

    // Other properties...
);
