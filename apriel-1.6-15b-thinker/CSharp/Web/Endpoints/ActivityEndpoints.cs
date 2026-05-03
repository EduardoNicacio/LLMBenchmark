using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using YourApp.Application.DTOs;
using YourApp.Infrastructure.Repositories;
using System.Data;
using System.Threading.Tasks;

namespace YourApp.Web.Endpoints
{
    /// <summary>
    /// Minimal API endpoints for activities.
    /// </summary>
    public static class ActivityEndpoints
    {
        public static IEndpointRouteBuilder MapActivityEndpoints(this IEndpointRouteBuilder app)
        {
            var routes = app.MapGroup("/api/activities")
                .Select(routes => routes
                    // GET collection
                    .MapGet(async (IActivityRepository repo, CancellationToken ct) =>
                    {
                        var list = await repo.GetAllAsync(ct);
                        return Results.Ok(list.Select(ActivityMappingExtensions.ToReadDto));
                    })
                    .WithName("GetAll")
                    .WithTags("Activities")
                    .EndpointSummary("List all activities")
                    .EndpointDescription("Returns every non‑deleted activity.")
                    // GET single
                    .MapGet(async (IActivityRepository repo, Guid id, CancellationToken ct) =>
                    {
                        var entity = await repo.GetByIdAsync(id, ct);
                        if (entity == null)
                            return Results.NotFound();
                        return Results.Ok(ActivityMappingExtensions.ToReadDto(entity));
                    })
                    .WithName("GetOne")
                    .WithTags("Activities")
                    .EndpointSummary("Get activity by ID")
                    .EndpointDescription("Returns a single activity or 404.")
                    // POST create
                    .MapPost(async (IActivityRepository repo, ActivityCreateDto dto, CancellationToken ct) =>
                    {
                        try
                        {
                            var entity = ActivityMappingExtensions.ToEntity(dto);
                            await repo.AddAsync(entity, ct);
                            await repo.SaveChangesAsync(ct);
                            return Results.Created($"/api/activities/{entity.ActivityId}", ActivityMappingExtensions.ToReadDto(entity));
                        }
                        catch (DbUpdateException ex)
                        {
                            // Validation errors are surfaced as 422 by the framework.
                            return Results.Problem(422, new ProblemDetails
                            {
                                Title = "Validation error",
                                Detail = ex.Message,
                                TraceId = Guid.NewGuid().ToString()
                            });
                        }
                    })
                    .WithName("Create")
                    .WithTags("Activities")
                    .EndpointSummary("Create a new activity")
                    .EndpointDescription("Accepts an ActivityCreateDto and returns the created resource.")
                    // PUT update
                    .MapPut(async (IActivityRepository repo, Guid id, ActivityUpdateDto dto, CancellationToken ct) =>
                    {
                        try
                        {
                            var existing = await repo.GetByIdAsync(id, ct);
                            if (existing == null)
                                return Results.NotFound();

                            // Concurrency check – SystemTimestamp must match.
                            ActivityMappingExtensions.ApplyUpdate(existing, dto);
                            await repo.UpdateAsync(existing, ct);
                            await repo.SaveChangesAsync(ct);
                            return Results.NoContent();
                        }
                        catch (DbUpdateConcurrencyException)
                        {
                            return Results.Problem(409, new ProblemDetails
                            {
                                Title = "Concurrency conflict",
                                Detail = "The activity has been modified by another request."
                            });
                        }
                    })
                    .WithName("Update")
                    .WithTags("Activities")
                    .EndpointSummary("Update an existing activity")
                    .EndpointDescription("Handles optimistic concurrency.")
                    // DELETE soft
                    .MapDelete(async (IActivityRepository repo, Guid id, CancellationToken ct) =>
                    {
                        await repo.DeleteAsync(id, ct);
                        return Results.NoContent();
                    })
                    .WithName("Delete")
                    .WithTags("Activities")
                    .EndpointSummary("Soft‑delete an activity")
                    .EndpointDescription("Marks the record as deleted without removing it.")
                );

            return routes;
        }
    }
}
