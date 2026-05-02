// src/API/Controllers/ActivityApiController.cs
using Microsoft.AspNetCore.Mvc;
using MyApp.Data.Dtos;
using MyApp.Data.Repositories;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ActivityApiController : ControllerBase
{
    private readonly IActivityRepository _activityRepository;

    public ActivityApiController(IActivityRepository activityRepository)
        => _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));

    // GET: api/activities
    [HttpGet]
    public async Task<ActionResult<List<ReadActivityDto>>> GetActivities()
    {
        var items = await _activityRepository.GetAllWithDetailsAsync();
        return Ok(items);
    }

    // GET: api/activities/{id}
    [HttpGet("{id}")]
    public async Task<ActionResult<ReadActivityDto>> GetActivity(Guid id)
    {
        var item = await _activityRepository.GetByIdAsync(id);
        if (item == null) return NotFound();

        return Ok(item);
    }

    // POST: api/activities
    [HttpPost]
    public async Task<ActionResult<Guid>> PostActivity(CreateActivityDto dto, CancellationToken ct)
    {
        // Map DTO -> Entity + set audit fields
        var activity = new Activity
        {
            ProjectId      = Guid.Parse(dto.ProjectId),
            ProjectMemberId= Guid.Parse(dto.ProjectMemberId),
            Name           = dto.Name,
            Description    = dto.Description,
            StartDate      = dto.StartDate ?? DateTime.MinValue,
            TargetDate     = dto.TargetDate ?? DateTime.MinValue,
            ProgressStatus = dto.ProgressStatus,
            ActivityPoints = dto.ActivityPoints,
            Priority       = dto.Priority,
            Risk           = dto.Risk,
            Tags           = dto.Tags,
            ActiveFlag     = dto.ActiveFlag,
            SystemDeleteFlag= dto.SystemDeleteFlag,
            CreatedDateTime  = DateTime.UtcNow,
            CreatedByUser    = dto.CreatedByUser ?? "System",
            CreatedByProgram = dto.CreatedByProgram ?? "API"
        };

        await _activityRepository.AddAsync(activity);
        return CreatedAtAction(nameof(GetActivity), new { id = activity.ActivityId }, activity.ActivityId);
    }

    // PUT: api/activities/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> PutActivity(UpdateActivityDto dto, Guid id, CancellationToken ct)
    {
        if (id != Guid.Parse(dto.ActivityId))
        {
            return BadRequest("ID mismatch.");
        }

        var activity = await _activityRepository.GetByIdAsync(id);
        if (activity == null) return NotFound();

        // Apply updates
        activity.ProjectId      = Guid.Parse(dto.ProjectId);
        activity.ProjectMemberId= Guid.Parse(dto.ProjectMemberId);
        activity.Name          = dto.Name;
        activity.Description   = dto.Description;
        activity.StartDate     = dto.StartDate ?? activity.StartDate;
        activity.TargetDate    = dto.TargetDate ?? activity.TargetDate;
        activity.ProgressStatus = dto.ProgressStatus ?? activity.ProgressStatus;
        activity.ActivityPoints= dto.ActivityPoints ?? activity.ActivityPoints;
        activity.Priority      = dto.Priority ?? activity.Priority;
        activity.Risk          = dto.Risk ?? activity.Risk;
        activity.Tags          = dto.Tags;
        if (dto.ActiveFlag.HasValue) activity.ActiveFlag = dto.ActiveFlag.Value;

        await _activityRepository.UpdateAsync(activity);
        return NoContent();
    }

    // DELETE: api/activities/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteActivity(Guid id)
    {
        var exists = await _activityRepository.GetByIdAsync(id);
        if (exists == null) return NotFound();

        await _activityRepository.DeleteAsync(exists);
        return NoContent();
    }
}
