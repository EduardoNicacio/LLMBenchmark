using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Dtos;
using ProjectManagement.Models;

namespace ProjectManagement.Api
{
    public static class ActivityEndpoints
    {
        public static void MapActivityEndpoints(this WebApplication app)
        {
            var group = app.MapGroup("/api/activities")
                .RequireAuthorization();

            // GET all activities
            group.MapGet("/", async (IActivityRepository repository) =>
            {
                var activities = await repository.GetAllAsync();
                return Results.Ok(activities);
            });

            // GET activity by ID
            group.MapGet("/{id:guid}", async (Guid id, IActivityRepository repository) =>
            {
                var activity = await repository.GetByIdAsync(id);
                if (activity == null)
                {
                    return Results.NotFound();
                }
                return Results.Ok(activity);
            });

            // POST create new activity
            group.MapPost("/", async (
                ActivityCreateDto dto,
                IActivityRepository repository) =>
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
                    ProgressStatus = dto.ProgressStatus,
                    ActivityPoints = dto.ActivityPoints,
                    Priority = dto.Priority,
                    Risk = dto.Risk,
                    Tags = dto.Tags,
                    ActiveFlag = dto.ActiveFlag,
                    SystemDeleteFlag = "N",
                    CreatedDateTime = DateTime.UtcNow,
                    CreatedByUser = "API User", // Get from user context in real app
                    CreatedByProgram = "WebApp"
                };

                await repository.AddAsync(activity);
                return Results.Created($"/api/activities/{activity.ActivityId}", activity);
            });

            // PUT update activity
            group.MapPut("/{id:guid}", async (
                Guid id,
                ActivityUpdateDto dto,
                IActivityRepository repository) =>
            {
                var existingActivity = await repository.GetByIdAsync(id);
                if (existingActivity == null)
                {
                    return Results.NotFound();
                }

                // Update fields
                existingActivity.Name = dto.Name;
                existingActivity.Description = dto.Description;
                existingActivity.StartDate = dto.StartDate;
                existingActivity.TargetDate = dto.TargetDate;
                existingActivity.ProgressStatus = dto.ProgressStatus;
                existingActivity.ActivityPoints = dto.ActivityPoints;
                existingActivity.Priority = dto.Priority;
                existingActivity.Risk = dto.Risk;
                existingActivity.Tags = dto.Tags;
                existingActivity.ActiveFlag = dto.ActiveFlag;
                existingActivity.UpdatedDateTime = DateTime.UtcNow;
                existingActivity.UpdatedByUser = "API User"; // Get from user context
                existingActivity.UpdatedByProgram = "WebApp";

                repository.Update(existingActivity);
                return Results.NoContent();
            });

            // DELETE activity (soft delete)
            group.MapDelete("/{id:guid}", async (
                Guid id,
                IActivityRepository repository) =>
            {
                var activity = await repository.GetByIdAsync(id);
                if (activity == null)
                {
                    return Results.NotFound();
                }

                activity.SystemDeleteFlag = "Y";
                activity.UpdatedDateTime = DateTime.UtcNow;
                activity.UpdatedByUser = "API User"; // Get from user context
                activity.UpdatedByProgram = "WebApp";

                repository.Update(activity);
                return Results.NoContent();
            });
        }
    }
}
