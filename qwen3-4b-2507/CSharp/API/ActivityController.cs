// Minimal API: ActivityController.cs
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

[Route("api/[controller]")]
[ApiController]
public class ActivityController : ControllerBase
{
    private readonly IGenericRepository<ActivityModel> _repository;

    public ActivityController(IGenericRepository<ActivityModel> repository)
    {
        _repository = repository;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ReadActivityDto>>> Get()
    {
        var activities = await _repository.GetAllAsync();
        var dtoList = activities.Select(a => new ReadActivityDto
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
            UpdatedByProgram = a.UpdatedByProgram
        }).ToList();

        return Ok(dtoList);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ReadActivityDto>> Get(Guid id)
    {
        var activity = await _repository.GetByIdAsync(id);
        if (activity == null)
            return NotFound();

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
            UpdatedByProgram = activity.UpdatedByProgram
        };

        return Ok(dto);
    }

    [HttpPost]
    public async Task<ActionResult<ReadActivityDto>> Post(CreateActivityDto dto)
    {
        var activity = new ActivityModel
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
            ActiveFlag = dto.ActiveFlag,
            SystemDeleteFlag = dto.SystemDeleteFlag,
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = dto.CreatedByUser,
            CreatedByProgram = dto.CreatedByProgram
        };

        await _repository.AddAsync(activity);
        var dtoResponse = new ReadActivityDto
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
            UpdatedByProgram = activity.UpdatedByProgram
        };

        return CreatedAtAction(nameof(Get), new { id = activity.ActivityId }, dtoResponse);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Put(Guid id, UpdateActivityDto dto)
    {
        var activity = await _repository.GetByIdAsync(id);
        if (activity == null)
            return NotFound();

        activity.ProjectId = dto.ProjectId ?? activity.ProjectId;
        activity.ProjectMemberId = dto.ProjectMemberId ?? activity.ProjectMemberId;
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
        activity.ActiveFlag = dto.ActiveFlag ?? activity.ActiveFlag;
        activity.SystemDeleteFlag = dto.SystemDeleteFlag ?? activity.SystemDeleteFlag;
        activity.UpdatedDateTime = dto.UpdatedDateTime;
        activity.UpdatedByUser = dto.UpdatedByUser;
        activity.UpdatedByProgram = dto.UpdatedByProgram;

        await _repository.UpdateAsync(activity);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var activity = await _repository.GetByIdAsync(id);
        if (activity == null)
            return NotFound();

        await _repository.DeleteAsync(activity);
        return NoContent();
    }
}
