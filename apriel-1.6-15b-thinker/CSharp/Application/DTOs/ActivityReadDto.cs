using System.ComponentModel.DataAnnotations;

namespace YourApp.Application.DTOs
{
    /// <summary>
    /// DTO returned to clients; excludes internal concurrency data.
    /// </summary>
    public sealed record ActivityReadDto(
        Guid ActivityId,
        Guid ProjectId,
        Guid ProjectMemberId,
        string Name,
        string Description,
        DateOnly? StartDate,
        DateOnly? TargetDate,
        DateOnly? EndDate,
        byte? ProgressStatus,
        short? ActivityPoints,
        byte? Priority,
        byte? Risk,
        string? Tags,
        byte ActiveFlag,
        string SystemDeleteFlag,
        DateTime CreatedDateTime,
        string CreatedByUser,
        string CreatedByProgram,
        DateTime? UpdatedDateTime,
        string? UpdatedByUser,
        string? UpdatedByProgram
    );
}
