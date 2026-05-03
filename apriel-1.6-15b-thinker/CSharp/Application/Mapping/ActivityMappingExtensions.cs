using YourApp.Application.DTOs;
using YourApp.Domain.Entities;

namespace YourApp.Application.Mapping
{
    /// <summary>
    /// Mapping extensions between DTOs and the <see cref="Activity"/> entity.
    /// </summary>
    public static class ActivityMappingExtensions
    {
        /// <summary>
        /// Projects a create DTO to a new <see cref="Activity"/> instance.
        /// </summary>
        public static Activity ToEntity(ActivityCreateDto dto) => new Activity
        {
            ProjectId = dto.ProjectId,
            ProjectMemberId = dto.ProjectMemberId,
            Name = dto.Name,
            Description = dto.Description,
            StartDate = dto.StartDate,
            TargetDate = dto.TargetDate,
            EndDate = dto.EndDate,
            ProgressStatus = dto.ProgressStatus,
            ActivityPoints = dto.ActivityPoints,
            Priority = dto.Priority,
            Risk = dto.Risk,
            Tags = dto.Tags,
            ActiveFlag = dto.ActiveFlag ?? 1,
            SystemDeleteFlag = "N",
        };

        /// <summary>
        /// Applies an update DTO to an existing <see cref="Activity"/> instance.
        /// </summary>
        public static void ApplyUpdate(Activity entity, ActivityUpdateDto dto)
        {
            if (dto.ProjectId.HasValue) entity.ProjectId = dto.ProjectId.Value;
            if (dto.ProjectMemberId.HasValue) entity.ProjectMemberId = dto.ProjectMemberId.Value;
            if (!string.IsNullOrWhiteSpace(dto.Name)) entity.Name = dto.Name;
            if (!string.IsNullOrWhiteSpace(dto.Description)) entity.Description = dto.Description;
            if (dto.StartDate.HasValue) entity.StartDate = dto.StartDate.Value;
            if (dto.TargetDate.HasValue) entity.TargetDate = dto.TargetDate.Value;
            if (dto.EndDate.HasValue) entity.EndDate = dto.EndDate.Value;
            if (dto.ProgressStatus.HasValue) entity.ProgressStatus = dto.ProgressStatus.Value;
            if (dto.ActivityPoints.HasValue) entity.ActivityPoints = dto.ActivityPoints.Value;
            if (dto.Priority.HasValue) entity.Priority = dto.Priority.Value;
            if (dto.Risk.HasValue) entity.Risk = dto.Risk.Value;
            if (!string.IsNullOrWhiteSpace(dto.Tags)) entity.Tags = dto.Tags;
            if (dto.ActiveFlag.HasValue) entity.ActiveFlag = dto.ActiveFlag.Value;
        }

        /// <summary>
        /// Projects an <see cref="Activity"/> to a read DTO.
        /// </summary>
        public static ActivityReadDto ToReadDto(Activity entity) => new ActivityReadDto
        {
            ActivityId = entity.ActivityId,
            ProjectId = entity.ProjectId,
            ProjectMemberId = entity.ProjectMemberId,
            Name = entity.Name,
            Description = entity.Description,
            StartDate = entity.StartDate,
            TargetDate = entity.TargetDate,
            EndDate = entity.EndDate,
            ProgressStatus = entity.ProgressStatus,
            ActivityPoints = entity.ActivityPoints,
            Priority = entity.Priority,
            Risk = entity.Risk,
            Tags = entity.Tags,
            ActiveFlag = entity.ActiveFlag,
            SystemDeleteFlag = entity.SystemDeleteFlag,
            CreatedDateTime = entity.CreatedDateTime,
            CreatedByUser = entity.CreatedByUser,
            CreatedByProgram = entity.CreatedByProgram,
            UpdatedDateTime = entity.UpdatedDateTime,
            UpdatedByUser = entity.UpdatedByUser,
            UpdatedByProgram = entity.UpdatedByProgram
        };
    }
}
