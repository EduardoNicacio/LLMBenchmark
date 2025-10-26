using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MyApp.Data;
using MyApp.DTOs;
using MyApp.Models;
using MyApp.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Register EF Core DbContext.
builder.Services.AddDbContext<MyAppContext>(options =>
options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register Activity repository.
builder.Services.AddScoped<IActivityRepository, ActivityRepository>();

var app = builder.Build();

// Minimal API endpoints for CRUD operations on Activity.

// GET: List Activities
app.MapGet("/api/activities", async (IActivityRepository repo) =>
{
    var activities = await repo.GetAllAsync();
    return Results.Ok(activities);
});

// POST: Create new Activity.
app.MapPost("/api/activities", async (ActivityCreateDto dto, IActivityRepository repo) =>
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
        ActiveFlag = dto.ActiveFlag,
        SystemDeleteFlag = dto.SystemDeleteFlag,
        CreatedDateTime = dto.CreatedDateTime,
        CreatedByUser = dto.CreatedByUser,
        CreatedByProgram = dto.CreatedByProgram
    };

    await repo.Add(activity);
    await repo.SaveChangesAsync();
    return Results.Created($"/api/activities/{activity.ActivityId}", activity);
});

// GET: Retrieve a single Activity.
app.MapGet("/api/activities/{id}", async (Guid id, IActivityRepository repo) =>
{
    var activity = await repo.GetByIdAsync(id);
    if (activity == null)
        return Results.NotFound();

    return Results.Ok(activity);
});

// PUT: Update an existing Activity.
app.MapPut("/api/activities/{id}", async (Guid id, ActivityUpdateDto updateDto, IActivityRepository repo) =>
{
    var activity = await repo.GetByIdAsync(id);
    if (activity == null)
        return Results.NotFound();

    // Map properties from DTO to entity.
    activity.Name = updateDto.Name ?? activity.Name;
    activity.Description = updateDto.Description ?? activity.Description;
    activity.StartDate = updateDto.StartDate ?? activity.StartDate;
    activity.TargetDate = updateDto.TargetDate ?? activity.TargetDate;
    activity.EndDate = updateDto.EndDate ?? activity.EndDate;
    if (updateDto.ProgressStatus.HasValue)
        activity.ProgressStatus = updateDto.ProgressStatus.Value;
    if (updateDto.ActivityPoints.HasValue)
        activity.ActivityPoints = updateDto.ActivityPoints.Value;
    if (updateDto.Priority.HasValue)
        activity.Priority = updateDto.Priority.Value;
    if (updateDto.Risk.HasValue)
        activity.Risk = updateDto.Risk.Value;
    activity.Tags = updateDto.Tags ?? activity.Tags;
    activity.ActiveFlag = updateDto.ActiveFlag;
    activity.SystemDeleteFlag = updateDto.SystemDeleteFlag;

    // Optional: update updated info.
    activity.UpdatedDateTime = updateDto.UpdatedDateTime ?? activity.UpdatedDateTime;
    activity.UpdatedByUser = updateDto.UpdatedByUser ?? activity.UpdatedByUser;
    activity.UpdatedByProgram = updateDto.UpdatedByProgram ?? activity.UpdatedByProgram;

    repo.Update(activity);
    await repo.SaveChangesAsync();
    return Results.Ok(activity);
});

// DELETE: Remove an Activity.
app.MapDelete("/api/activities/{id}", async (Guid id, IActivityRepository repo) =>
{
    var activity = await repo.GetByIdAsync(id);
    if (activity == null)
        return Results.NotFound();

    // For a soft delete you might update SystemDeleteFlag instead.
    repo.Delete(activity);
    await repo.SaveChangesAsync();
    return Results.Ok();
});