// Controllers/Activities.cs
using Microsoft.AspNetCore.Mvc;
using MyApp.Models.Dtos;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ActivitiesController : ControllerBase
    {
        private readonly IActivityRepository _activityRepo;

        public ActivitiesController(IActivityRepository activityRepo)
        {
            _activityRepo = activityRepo;
        }

        // GET: api/Activities
        [HttpGet]
        public async Task<ActionResult<IReadOnlyList<ActivityReadDto>>> GetAll()
        {
            var activities = await _activityRepo.ListAllAsync();
            return Ok(activities);
        }

        // GET: api/Activities/{id}
        [HttpGet("{id}", Name = "GetActivity")]
        public async Task<ActionResult<ActivityReadDto>> Get(Guid id)
        {
            var activity = await _activityRepo.GetByIdAsync(id.ToString());
            if (activity == null) return NotFound();
            return Ok(new ActivityReadDto
            {
                ActivityId = activity.Id,
                ProjectId = activity.ProjectId,
                ProjectMemberId = activity.ProjectMemberId,
                Name = activity.Name,
                Description = activity.Description,
                StartDate = activity.StartDate,
                TargetDate = activity.TargetDate,
                EndDate = activity.EndDate,
                ProgressStatus = activity.ProgressStatus,
                ActivityPoints = activity.ActivityPoints,
                Priority = activity.Priority,
                Risk = activity.Risk,
                Tags = activity.Tags,
                ActiveFlag = activity.ActiveFlag,
                SystemDeleteFlag = activity.SystemDeleteFlag,
                CreatedDateTime = activity.CreatedDateTime,
                CreatedByUser = activity.CreatedByUser,
                CreatedByProgram = activity.CreatedByProgram,
                UpdatedDateTime = activity.UpdatedDateTime,
                UpdatedByUser = activity.UpdatedByUser,
                UpdatedByProgram = activity.UpdatedByProgram
            });
        }

        // POST: api/Activities
        [HttpPost]
        public async Task<ActionResult<ActivityReadDto>> Create([FromBody] ActivityCreateDto dto)
        {
            var validation = ModelState.TryValidateAsync(dto, out var results);
            if (!validation) return BadRequest(results);

            var activity = new Models.Activity
            {
                ProjectId = dto.ProjectId,
                ProjectMemberId = dto.ProjectMemberId,
                Name = dto.Name,
                Description = dto.Description,
                StartDate = dto.StartDate ?? null,
                TargetDate = dto.TargetDate ?? null,
                EndDate = dto.EndDate ?? null,
                ProgressStatus = dto.ProgressStatus,
                ActivityPoints = dto.ActivityPoints,
                Priority = dto.Priority,
                Risk = dto.Risk,
                Tags = dto.Tags,
                ActiveFlag = dto.ActiveFlag,
                SystemDeleteFlag = dto.SystemDeleteFlag,
                CreatedByUser = "SYSTEM",
                CreatedByProgram = "API.CreateActivity",
                UpdatedDateTime = null
            };
            activity.CreatedDateTime = DateTime.UtcNow;

            await _activityRepo.AddAsync(activity);
            // Commit is implicit via repository's SaveChanges (see DI below)

            return CreatedAtAction(nameof(Get), new { id = activity.Id }, BuildReadDto(activity));
        }

        // PUT: api/Activities/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<ActivityReadDto>> Update(Guid id, [FromBody] ActivityUpdateDto dto)
        {
            var validation = ModelState.TryValidateAsync(dto, out var results);
            if (!validation) return BadRequest(results);

            var activity = await _activityRepo.GetByIdAsync(id.ToString());
            if (activity == null) return NotFound();

            // Apply changes
            if (dto.Name != null) activity.Name = dto.Name;
            if (dto.Description != null) activity.Description = dto.Description;
            if (dto.StartDate != null) activity.StartDate = dto.StartDate;
            if (dto.TargetDate != null) activity.TargetDate = dto.TargetDate;
            if (dto.EndDate != null) activity.EndDate = dto.EndDate;
            if (dto.ProgressStatus != null) activity.ProgressStatus = dto.ProgressStatus;
            if (dto.ActivityPoints != null) activity.ActivityPoints = dto.ActivityPoints;
            if (dto.Priority != null) activity.Priority = dto.Priority;
            if (dto.Risk != null) activity.Risk = dto.Risk;
            if (dto.Tags != null) activity.Tags = dto.Tags;

            if (dto.ActiveFlag.HasValue) activity.ActiveFlag = dto.ActiveFlag.Value;
            if (dto.SystemDeleteFlag.HasValue) activity.SystemDeleteFlag = dto.SystemDeleteFlag.Value;

            // Update timestamps
            activity.UpdatedDateTime = DateTime.UtcNow;
            var now = DateTime.UtcNow;
            activity.UpdatedByUser = "SYSTEM";
            activity.UpdatedByProgram = "API.UpdateActivity";

            await _activityRepo.UpdateAsync(activity);
            return Ok(BuildReadDto(activity));
        }

        // DELETE: api/Activities/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var activity = await _activityRepo.GetByIdAsync(id.ToString());
            if (activity == null) return NotFound();

            // Soft‑delete – set SystemDeleteFlag to 'Y' and timestamp
            activity.SystemDeleteFlag = 'Y';
            activity.UpdatedDateTime = DateTime.UtcNow;
            activity.UpdatedByUser = "SYSTEM";
            activity.UpdatedByProgram = "API.DeleteActivity";

            await _activityRepo.UpdateAsync(activity);
            return Ok(new { deletedId = id });
        }

        // Helper to map entity → DTO (avoid duplication)
        private static ActivityReadDto BuildReadDto(MyApp.Models.Activity act)
        {
            var dto = new ActivityReadDto
            {
                ActivityId = act.Id,
                ProjectId = act.ProjectId,
                ProjectMemberId = act.ProjectMemberId,
                Name = act.Name,
                Description = act.Description,
                StartDate = act.StartDate,
                TargetDate = act.TargetDate,
                EndDate = act.EndDate,
                ProgressStatus = act.ProgressStatus,
                ActivityPoints = act.ActivityPoints,
                Priority = act.Priority,
                Risk = act.Risk,
                Tags = act.Tags,
                ActiveFlag = act.ActiveFlag,
                SystemDeleteFlag = act.SystemDeleteFlag,
                CreatedDateTime = act.CreatedDateTime,
                CreatedByUser = act.CreatedByUser,
                CreatedByProgram = act.CreatedByProgram,
                UpdatedDateTime = act.UpdatedDateTime,
                UpdatedByUser = act.UpdatedByUser,
                UpdatedByProgram = act.UpdatedByProgram
            };
            return dto;
        }
    }
}
