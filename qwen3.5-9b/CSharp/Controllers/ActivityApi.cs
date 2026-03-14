using ActivityApp.Dtos;
using ActivityApp.Models;
using ActivityApp.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace ActivityApp.Api
{
    /// <summary>
    /// Minimal API Controller for Activity CRUD operations.
    /// </summary>
    public static class ActivityApi
    {
        public static void MapActivityEndpoints(this WebApplication app)
        {
            var logger = app.Services.GetRequiredService<ILogger<ActivityApi>>();

            // GET: /api/activities
            app.MapGet("/api/activities", async (ActivityRepository repo) =>
            {
                var activities = await repo.GetAllAsync();
                return Results.Ok(activities);
            });

            // GET: /api/activities/{id}
            app.MapGet("/api/activities/{id:guid}", async (Guid id, ActivityRepository repo) =>
            {
                var activity = await repo.GetByIdAsync(id);
                if (activity == null)
                    return Results.NotFound();
                return Results.Ok(activity);
            });

            // POST: /api/activities
            app.MapPost("/api/activities", async (ActivityCreateDto dto, ActivityRepository repo) =>
            {
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
                    ActiveFlag = true,
                    SystemDeleteFlag = false
                };

                await repo.AddAsync(activity);
                return Results.Created($"/api/activities/{activity.ActivityId}", activity);
            });

            // PUT: /api/activities/{id}
            app.MapPut("/api/activities/{id:guid}", async (Guid id, ActivityUpdateDto dto, ActivityRepository repo) =>
            {
                var activity = await repo.GetByIdAsync(id);
                if (activity == null)
                    return Results.NotFound();

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
                activity.ActiveFlag = dto.ActiveFlag;

                await repo.UpdateAsync(activity);
                return Results.NoContent();
            });

            // DELETE: /api/activities/{id}
            app.MapDelete("/api/activities/{id:guid}", async (Guid id, ActivityRepository repo) =>
            {
                await repo.DeleteAsync(id);
                return Results.NoContent();
            });
        }
    }
}
