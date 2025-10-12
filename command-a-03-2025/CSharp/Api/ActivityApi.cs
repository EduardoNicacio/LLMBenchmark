using ActivityTracker.DTOs;
using ActivityTracker.Models;
using ActivityTracker.Repository;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading.Tasks;

namespace ActivityTracker.Api
{
    public static class ActivityApi
    {
        public static void MapActivityEndpoints(this WebApplication app)
        {
            var activityGroup = app.MapGroup("/api/activities");

            activityGroup.MapGet("/", async (IActivityRepository repo) =>
            {
                var activities = await repo.GetAllAsync();
                return Results.Ok(activities);
            });

            activityGroup.MapGet("/{id}", async (Guid id, IActivityRepository repo) =>
            {
                var activity = await repo.GetByIdAsync(id);
                return activity != null ? Results.Ok(activity) : Results.NotFound();
            });

            activityGroup.MapPost("/", async ([FromBody] CreateActivityDto dto, IActivityRepository repo) =>
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

                await repo.AddAsync(activity);
                return Results.Created($"/api/activities/{activity.ActivityId}", activity);
            });

            activityGroup.MapPut("/{id}", async (Guid id, [FromBody] UpdateActivityDto dto, IActivityRepository repo) =>
            {
                var activity = await repo.GetByIdAsync(id);
                if (activity == null) return Results.NotFound();

                activity.ProjectId = dto.ProjectId;
                activity.ProjectMemberId = dto.ProjectMemberId;
                activity.Name = dto.Name;
                activity.Description = dto.Description;
                activity.StartDate = dto.StartDate;
                activity.TargetDate = dto.TargetDate;
                activity.EndDate = dto.EndDate;
                activity.ProgressStatus = dto.ProgressStatus;
                activity.ActivityPoints = dto.ActivityPoints;
                activity.Priority = dto.Priority;
                activity.Risk = dto.Risk;
                activity.Tags = dto.Tags;
                activity.ActiveFlag = dto.ActiveFlag;
                activity.SystemDeleteFlag = dto.SystemDeleteFlag;
                activity.UpdatedDateTime = DateTime.UtcNow;
                activity.UpdatedByUser = dto.UpdatedByUser;
                activity.UpdatedByProgram = dto.UpdatedByProgram;

                await repo.UpdateAsync(activity);
                return Results.NoContent();
            });

            activityGroup.MapDelete("/{id}", async (Guid id, IActivityRepository repo) =>
            {
                var activity = await repo.GetByIdAsync(id);
                if (activity == null) return Results.NotFound();

                await repo.DeleteAsync(activity);
                return Results.NoContent();
            });
        }
    }
}
