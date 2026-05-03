using System.ComponentModel.DataAnnotations;

namespace YourApp.Application.DTOs
{
    /// <summary>
    /// DTO used to update an existing activity. Includes the concurrency token.
    /// </summary>
    public sealed record ActivityUpdateDto(
        Guid? ProjectId,
        Guid? ProjectMemberId,
        [MaxLength(128)] string? Name,
        [MaxLength(4000)] string? Description,
        DateOnly? StartDate,
        DateOnly? TargetDate,
        DateOnly? EndDate,
        byte? ProgressStatus,
        short? ActivityPoints,
        byte? Priority,
        byte? Risk,
        [MaxLength(200)] string? Tags,
        byte? ActiveFlag,
        [Required] byte[] SystemTimestamp
    );
}
