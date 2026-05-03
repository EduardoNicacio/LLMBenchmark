// ActivityEndpoints.cs
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace YourApp.Web.Endpoints;

public static class ActivityEndpoints
{
    public static IEndpointRouteBuilder MapActivityEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/activities").WithTags("Activities");

        group.MapGet("/", async ([FromServices] IActivityRepository repository, CancellationToken ct) =>
            Results.Ok((await repository.GetActiveAsync(ct)).Select(a => a.ToDto()));

        group.MapGet("/{id:guid}", async (Guid id, [FromServices] IActivityRepository repository, CancellationToken ct) =>
            await repository.GetByIdAsync(id, ct) is Activity activity ? Results.Ok(activity.ToDto()) : Results.NotFound());

        group.MapPost("/", async ([FromBody] ActivityCreateDto dto, [FromServices] IActivityRepository repository, CancellationToken ct) =>
            await repository.AddAsync(dto.ToEntity(), ct);
            return await repository.SaveChangesAsync(ct) > 0 ? Results.CreatedAtRoute("GetActivity", new { id = activity.ActivityId }, activity.ToDto()) : Results.BadRequest());

        group.MapPut("/{id:guid}", async (Guid id, [FromBody] ActivityUpdateDto dto, [FromServices] IActivityRepository repository, CancellationToken ct) =>
            if (await repository.GetByIdAsync(id, ct) is not { } existing || !existing.SystemTimestamp.SequenceEqual(dto.SystemTimestamp)) return Results.NotFound();
            var updated = dto.ToEntity();
            _context.Entry(existing).CurrentValues.SetValues(updated);
            try
            {
                await repository.SaveChangesAsync(ct);
                return Results.NoContent();
            }
            catch (DbUpdateConcurrencyException)
            {
                return Results.Conflict("The activity was updated by another user.");
            }
        );

        group.MapDelete("/{id:guid}", async (Guid id, [FromServices] IActivityRepository repository, CancellationToken ct) =>
            await repository.DeleteAsync(id, ct);
            return await repository.SaveChangesAsync(ct) > 0 ? Results.NoContent() : Results.NotFound());

        return app;
    }
}
