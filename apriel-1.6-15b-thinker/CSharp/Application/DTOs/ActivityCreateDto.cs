using System.ComponentModel.DataAnnotations;

namespace YourApp.Application.DTOs
{
    /// <summary>
    /// DTO used to create a new activity.
    /// </summary>
    public sealed record ActivityCreateDto(
        [Required] Guid ProjectId,
        [Required] Guid ProjectMemberId,
        [Required, MaxLength(128)] string Name,
        [Required, MaxLength(4000)] string Description,
        DateOnly? StartDate,
        DateOnly? TargetDate,
        DateOnly? EndDate,
        byte? ProgressStatus,
        short? ActivityPoints,
        byte? Priority,
        byte? Risk,
        [MaxLength(200)] string? Tags,
        [Required] byte ActiveFlag
    );
}
