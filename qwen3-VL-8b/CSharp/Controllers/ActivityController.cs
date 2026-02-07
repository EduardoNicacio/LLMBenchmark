// Minimal API Controller: ActivityController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using YourProject.DTOs;
using YourProject.Repositories;

namespace YourProject.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ActivityController : ControllerBase
    {
        private readonly IActivityRepository _activityRepository;

        public ActivityController(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var activities = await _activityRepository.GetAllAsync();
            return Ok(activities);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var activity = await _activityRepository.GetByIdAsync(id);
            if (activity == null)
                return NotFound();

            return Ok(activity);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateActivityDto dto)
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
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
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "API",
                CreatedByProgram = "MinimalAPI",
                UpdatedDateTime = null,
                UpdatedByUser = null,
                UpdatedByProgram = null,
                SystemTimestamp = new byte[8] // Initialize to default timestamp
            };

            await _activityRepository.AddAsync(activity);
            return CreatedAtAction(nameof(GetById), new { id = activity.ActivityId }, activity);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, [FromBody] UpdateActivityDto dto)
        {
            var activity = await _activityRepository.GetByIdAsync(id);
            if (activity == null)
                return NotFound();

            activity.ProjectId = dto.ProjectId;
            activity.ProjectMemberId = dto.ProjectMemberId;
            activity.Name = dto.Name ?? activity.Name;
            activity.Description = dto.Description ?? activity.Description;
            activity.StartDate = dto.StartDate;
            activity.TargetDate = dto.TargetDate;
            activity.EndDate = dto.EndDate;
            activity.ProgressStatus = dto.ProgressStatus;
            activity.ActivityPoints = dto.ActivityPoints;
            activity.Priority = dto.Priority;
            activity.Risk = dto.Risk;
            activity.Tags = dto.Tags;

            activity.UpdatedDateTime = DateTime.UtcNow;
            activity.UpdatedByUser = "API";
            activity.UpdatedByProgram = "MinimalAPI";

            await _activityRepository.UpdateAsync(activity);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await _activityRepository.DeleteAsync(id);
            return NoContent();
        }
    }
}
