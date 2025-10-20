using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using YourNamespace.Models.DTOs;
using YourNamespace.Repositories;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace YourNamespace.Endpoints
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ActivityController : ControllerBase
    {
        private readonly IActivityRepository _activityRepository;

        public ActivityController(IActivityRepository activityRepository)
        {
            _activityRepository = activityRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ReadActivityDto>>> GetAllActivities()
        {
            var activities = await _activityRepository.GetAllAsync();
            return Ok(activities.Select(a => new ReadActivityDto(a)));
        }

        [HttpGet("{activityId}")]
        public async Task<ActionResult<ReadActivityDto>> GetActivityById(Guid activityId)
        {
            var activity = await _activityRepository.GetByIdAsync(activityId);
            if (activity == null)
                return NotFound();

            return new ReadActivityDto(activity);
        }

        [HttpPost]
        public async Task<ActionResult<ReadActivityDto>> CreateActivity(CreateActivityDto createDto)
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(), // In real app, fetch from auth
                ProjectMemberId = Guid.NewGuid(), // In real app, fetch from auth
                Name = createDto.Name,
                Description = createDto.Description,
                StartDate = createDto.StartDate,
                TargetDate = createDto.TargetDate,
                EndDate = createDto.EndDate,
                ProgressStatus = createDto.ProgressStatus,
                ActivityPoints = createDto.ActivityPoints,
                Priority = createDto.Priority,
                Risk = createDto.Risk,
                Tags = createDto.Tags,
                ActiveFlag = createDto.ActiveFlag,
                SystemDeleteFlag = createDto.SystemDeleteFlag,
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = User.Identity?.Name ?? "System",
                CreatedByProgram = "API",
                SystemTimestamp = System.Timestamp
            };

            await _activityRepository.AddAsync(activity);
            return CreatedAtAction(nameof(GetActivityById), new { activityId = activity.ActivityId }, new ReadActivityDto(activity));
        }

        [HttpPut("{activityId}")]
        public async Task<IActionResult> UpdateActivity(Guid activityId, UpdateActivityDto updateDto)
        {
            var activity = await _activityRepository.GetByIdAsync(activityId);
            if (activity == null)
                return NotFound();

            // Update fields
            activity.Name = updateDto.Name;
            activity.Description = updateDto.Description;
            activity.StartDate = updateDto.StartDate;
            // ... (other fields)
            activity.ActiveFlag = updateDto.ActiveFlag;
            activity.SystemDeleteFlag = updateDto.SystemDeleteFlag;

            await _activityRepository.UpdateAsync(activity);
            return NoContent();
        }

        [HttpDelete("{activityId}")]
        public async Task<IActionResult> DeleteActivity(Guid activityId)
        {
            var activity = await _activityRepository.GetByIdAsync(activityId);
            if (activity == null)
                return NotFound();

            activity.SystemDeleteFlag = 'Y';
            activity.ActiveFlag = 0;
            await _activityRepository.DeleteAsync(activity);
            return NoContent();
        }
    }
}
