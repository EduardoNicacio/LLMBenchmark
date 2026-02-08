using Microsoft.EntityFrameworkCore;
using System;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<IActivityRepository, ActivityRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.

app.MapGet("/activities", async (IActivityRepository repository) =>
{
    var activities = await repository.GetAllAsync();
    return Results.Ok(activities.Select(a => new ReadActivityDto
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
        IsDeleted = a.SystemDeleteFlag,
        CreatedDateTime = a.CreatedDateTime,
        CreatedByUser = a.CreatedByUser,
        CreatedByProgram = a.CreatedByProgram,
        UpdatedDateTime = a.UpdatedDateTime,
        UpdatedByUser = a.UpdatedByUser,
        UpdatedByProgram = a.UpdatedByProgram
    }));
});

app.MapGet("/activities/{id}", async (Guid id, IActivityRepository repository) =>
{
    var activity = await repository.GetByIdAsync(id);
    if (activity == null)
    {
        return Results.NotFound();
    }
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
        IsDeleted = activity.SystemDeleteFlag,
        CreatedDateTime = activity.CreatedDateTime,
        CreatedByUser = activity.CreatedByUser,
        CreatedByProgram = activity.CreatedByProgram,
        UpdatedDateTime = activity.UpdatedDateTime,
        UpdatedByUser = activity.UpdatedByUser,
        UpdatedByProgram = activity.UpdatedByProgram
    };
    return Results.Ok(dto);
});

app.MapPost("/activities", async (CreateActivityDto dto, IActivityRepository repository) =>
{
    if (!dto.IsValid())
    {
        return Results.ValidationProblem();
    }

    var activity = new Activity
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
        CreatedByUser = "System", // In real app, get from claims
        CreatedByProgram = "API",
        UpdatedDateTime = null,
        UpdatedByUser = null,
        UpdatedByProgram = null
    };

    await repository.AddAsync(activity);
    return Results.Created($"/activities/{activity.ActivityId}", new ReadActivityDto
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
        IsDeleted = activity.SystemDeleteFlag,
        CreatedDateTime = activity.CreatedDateTime,
        CreatedByUser = activity.CreatedByUser,
        CreatedByProgram = activity.CreatedByProgram,
        UpdatedDateTime = activity.UpdatedDateTime,
        UpdatedByUser = activity.UpdatedByUser,
        UpdatedByProgram = activity.UpdatedByProgram
    });
});

app.MapPut("/activities/{id}", async (Guid id, UpdateActivityDto dto, IActivityRepository repository) =>
{
    if (!dto.IsValid())
    {
        return Results.ValidationProblem();
    }

    var existingActivity = await repository.GetByIdAsync(id);
    if (existingActivity == null)
    {
        return Results.NotFound();
    }

    // Soft delete check: don't allow updates to deleted items unless reactivating
    if (existingActivity.SystemDeleteFlag && !dto.SystemDeleteFlag)
    {
        return Results.BadRequest("Cannot update a soft-deleted activity.");
    }

    existingActivity.ProjectId = dto.ProjectId;
    existingActivity.ProjectMemberId = dto.ProjectMemberId;
    existingActivity.Name = dto.Name;
    existingActivity.Description = dto.Description;
    existingActivity.StartDate = dto.StartDate;
    existingActivity.TargetDate = dto.TargetDate;
    existingActivity.EndDate = dto.EndDate;
    existingActivity.ProgressStatus = dto.ProgressStatus;
    existingActivity.ActivityPoints = dto.ActivityPoints;
    existingActivity.Priority = dto.Priority;
    existingActivity.Risk = dto.Risk;
    existingActivity.Tags = dto.Tags;
    existingActivity.ActiveFlag = dto.ActiveFlag;
    existingActivity.SystemDeleteFlag = dto.SystemDeleteFlag;

    // Update audit fields
    existingActivity.UpdatedDateTime = DateTime.UtcNow;
    existingActivity.UpdatedByUser = "System";
    existingActivity.UpdatedByProgram = "API";

    repository.Update(existingActivity);
    return Results.NoContent();
});

app.MapDelete("/activities/{id}", async (Guid id, IActivityRepository repository) =>
{
    var activityToDelete = await repository.GetByIdAsync(id);
    if (activityToDelete == null)
    {
        return Results.NotFound();
    }

    // Soft delete
    activityToDelete.SystemDeleteFlag = true;
    activityToDelete.UpdatedDateTime = DateTime.UtcNow;
    activityToDelete.UpdatedByUser = "System";
    activityToDelete.UpdatedByProgram = "API";

    repository.Update(activityToDelete);
    return Results.NoContent();
});

app.Run();
