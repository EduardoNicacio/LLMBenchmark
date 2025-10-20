using System;
using System.ComponentModel.DataAnnotations;

namespace YourNamespace.Models.DTOs
{
    public record CreateActivityDto(
        [property: Required]
        [StringLength(128)]
        string Name,
        
        [property: Required]
        [StringLength(4000)]
        string Description,
        
        DateTime? StartDate,
        
        DateTime? TargetDate,
        
        DateTime? EndDate,
        
        byte? ProgressStatus,
        
        short? ActivityPoints,
        
        byte? Priority,
        
        byte? Risk,
        
        string? Tags,
        
        byte ActiveFlag,
        
        char SystemDeleteFlag,
        
        DateTime CreatedDateTime,
        
        string CreatedByUser,
        
        string CreatedByProgram
    );

    public record UpdateActivityDto(
        DateTime? StartDate,
        
        DateTime? TargetDate,
        
        DateTime? EndDate,
        
        byte? ProgressStatus,
        
        short? ActivityPoints,
        
        byte? Priority,
        
        byte? Risk,
        
        string? Tags,
        
        byte? ActiveFlag,
        
        char SystemDeleteFlag
    );

    public record ReadActivityDto(
        Guid ActivityId,
        
        Guid ProjectId,
        
        Guid ProjectMemberId,
        
        string Name,
        
        string Description,
        
        DateTime? StartDate,
        
        DateTime? TargetDate,
        
        DateTime? EndDate,
        
        byte? ProgressStatus,
        
        short? ActivityPoints,
        
        byte? Priority,
        
        byte? Risk,
        
        string? Tags,
        
        byte ActiveFlag,
        
        char SystemDeleteFlag,
        
        DateTime CreatedDateTime,
        
        string CreatedByUser,
        
        string CreatedByProgram,
        
        DateTime? UpdatedDateTime,
        
        string? UpdatedByUser,
        
        string? UpdatedByProgram,
        
        byte[] SystemTimestamp
    );
}
