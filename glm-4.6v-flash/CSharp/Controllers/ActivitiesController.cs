// ActivitiesController.cs - Minimal API for Activity operations
using Microsoft.AspNetCore.Mvc;
using YourApp.DTOs;
using YourApp.Models;

namespace YourApp.MinimalApi // Replace with your namespace

{
    [ApiController]
    [Route("api/[controller]")]
    public class ActivitiesController : ControllerBase
    {
        private readonly IRepository<Activity> _activityRepository; // DI
        
        public ActivitiesController(IRepository<Activity> activityRepository)
        {
            _activityRepository = activityRepository;
        }

        // GET: api/activities
        [HttpGet]
        public async Task<IActionResult> GetActivities()
        {
            var activities = _activityRepository.Get().Select(a => new ReadActivityDto
            {
                ActivityId = a.ActivityId,
                ProjectId = a.ProjectId,
                ProjectMemberId = a.ProjectMemberId,
                Name = a.Name,
                Description = a.Description,
                StartDate = a.StartDate,
                TargetDate = a.TargetDate,
                EndDate = a.EndDate,
                ProgressStatus = a.ProgressStatus,
                ActivityPoints = a.ActivityPoints,
                Priority = a.Priority,
                Risk = a.Risk,
                Tags = a.Tags,
                ActiveFlag = a.ActiveFlag,
                SystemDeleteFlag = a.SystemDeleteFlag,
                CreatedDateTime = a.CreatedDateTime,
                CreatedByUser = a.CreatedByUser,
                CreatedByProgram = a.CreatedByProgram,
                UpdatedDateTime = a.UpdatedDateTime,
                UpdatedByUser = a.UpdatedByUser,
                UpdatedByProgram = a.UpdatedByProgram,
                SystemTimestamp = a.SystemTimestamp
            }).ToList();
            
            return Ok(activities);
        }

        // GET: api/activities/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetActivity(Guid id)
        {
            var activity = _activityRepository.GetById(id);
            if (activity == null) return NotFound();
            
            var dto = new ReadActivityDto
            {
                ActivityId = activity.ActivityId,
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
                UpdatedByProgram = activity.UpdatedByProgram,
                SystemTimestamp = activity.SystemTimestamp
            };
            
            return Ok(dto);
        }

        // POST: api/activities
        [HttpPost]
        public async Task<IActionResult> PostActivity([FromBody] CreateActivityDto createDto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            
            var entity = new Activity
            {
                ProjectId = createDto.ProjectId,
                ProjectMemberId = createDto.ProjectMemberId,
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
                CreatedByUser = createDto.CreatedByUser,
                CreatedByProgram = createDto.CreatedByProgram
            };
            
            _activityRepository.Add(entity);
            
            return CreatedAtAction(nameof(GetActivity), new { id = entity.ActivityId }, entity);
        }

        // PUT: api/activities/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> PutActivity(Guid id, [FromBody] UpdateActivityDto updateDto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            
            var existing = _activityRepository.GetById(id);
            if (existing == null) return NotFound();
            
            // Update properties
            existing.ProjectId = updateDto.ProjectId;
            existing.ProjectMemberId = updateDto.ProjectMemberId;
            existing.Name = updateDto.Name;
            existing.Description = updateDto.Description;
            existing.StartDate = updateDto.StartDate;
            existing.TargetDate = updateDto.TargetDate;
            existing.EndDate = updateDto.EndDate;
            existing.ProgressStatus = updateDto.ProgressStatus;
            existing.ActivityPoints = updateDto.ActivityPoints;
            existing.Priority = updateDto.Priority;
            existing.Risk = updateDto.Risk;
            existing.Tags = updateDto.Tags;
            existing.ActiveFlag = updateDto.ActiveFlag;
            existing.SystemDeleteFlag = updateDto.SystemDeleteFlag;
            existing.UpdatedDateTime = DateTime.UtcNow;
            existing.UpdatedByUser = updateDto.UpdatedByUser;
            existing.UpdatedByProgram = updateDto.UpdatedByProgram;

            _activityRepository.Update(existing);
            
            return NoContent();
        }

        // DELETE: api/activities/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteActivity(Guid id)
        {
            var activity = _activityRepository.GetById(id);
            if (activity == null) return NotFound();
            
            _activityRepository.Delete(id); // Delete method expects id
            
            return NoContent();
        }
    }
}
