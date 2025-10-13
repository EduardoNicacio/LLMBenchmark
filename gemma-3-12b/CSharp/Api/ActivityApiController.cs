using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using MyApplication.Repositories;
using MyApplication.DTOs;
using Microsoft.AspNetCore.Authorization;

[ApiController]
[Route("api/activity")]
public class ActivityApiController : ControllerBase
{
    private readonly IActivityRepository _activityRepository;

    public ActivityApiController(IActivityRepository activityRepository)
    {
        _activityRepository = activityRepository ?? throw new ArgumentNullException(nameof(activityRepository));
    }

    [HttpGet]
    public ActionResult<IEnumerable<ActivityReadDto>> Get()
    {
        var activities = _activityRepository.Get();
        return Ok(activities.Select(a => new ActivityReadDto {
            ActivityId = a.ActivityId,
            Name = a.Name
        }));
    }

    [HttpGet("{id}")]
    public ActionResult<ActivityReadDto> Get(Guid id)
    {
        var activity = _activityRepository.Get(id);
        if (activity == null) return NotFound();
        return Ok(new ActivityReadDto {
            ActivityId = activity.ActivityId,
            Name = activity.Name
        });
    }

    [HttpPost]
    public ActionResult<Guid> Post([FromBody] ActivityCreateDto activityCreateDto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);
        _activityRepository.Add(activityCreateDto);
        return CreatedAtAction(nameof(Get), new { id = activityCreateDto.ProjectId }, null); // Return the created ID
    }

    [HttpPut("{id}")]
    public IActionResult Put(Guid id, [FromBody] ActivityUpdateDto activityUpdateDto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);
        activityUpdateDto.ActivityId = id; // Ensure update DTO has the correct ID
        _activityRepository.Update(activityUpdateDto);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(Guid id)
    {
        _activityRepository.Delete(id);
        return NoContent();
    }
}
