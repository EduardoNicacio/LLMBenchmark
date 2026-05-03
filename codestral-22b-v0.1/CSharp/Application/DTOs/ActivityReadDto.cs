// ActivityReadDto.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace YourApp.Application.DTOs;

public sealed record ActivityReadDto(
    public Guid ActivityId { get; init; },

    // Other properties...
);
