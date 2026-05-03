namespace YourApp.Web.Endpoints;

public static class ActivityEndpoints
{
    public static IEndpointRouteBuilder MapActivityEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/activities", async (IActivityRepository repo, CancellationToken ct) =>
            await repo.GetActiveAsync(ct))
            .WithTags("Activities")
            .Produces<IReadOnlyList<ActivityReadDto>>();

        app.MapGet("/api/activities/{id:guid}", async (Guid id, IActivityRepository repo, CancellationToken ct) =>
            {
                var activity = await repo.GetByIdAsync(id, ct);
                return activity is not null ? Results.Ok(activity.ToReadDto()) : Results.NotFound();
            })
            .WithTags("Activities")
            .Produces<ActivityReadDto>()
            .Produces(404);

        app.MapPost("/api/activities", async (ActivityCreateDto dto, IActivityRepository repo, CancellationToken ct) =>
            {
                var entity = dto.ToEntity();
                await repo.AddAsync(entity, ct);
                await repo.SaveChangesAsync(ct);
                return Results.CreatedAtRoute(entity.ToReadDto(), "GetActivity", new { id = entity.ActivityId });
            })
            .WithTags("Activities")
            .Produces<ActivityReadDto>(201)
            .ProducesValidationProblem(422)
            .RequireValidation();

        app.MapPut("/api/activities/{id:guid}", async (Guid id, ActivityUpdateDto dto, IActivityRepository repo, CancellationToken ct) =>
            {
                if (id != dto.ActivityId) return Results.BadRequest();
                
                var entity = await repo.GetByIdAsync(id, ct);
                if (entity is null) return Results.NotFound();
                if (!entity.SystemTimestamp.SequenceEqual(dto.SystemTimestamp)) return Results.Conflict();

                dto.UpdateEntity(entity);
                await repo.UpdateAsync(entity, ct);
                
                try
                {
                    await repo.SaveChangesAsync(ct);
                    return Results.NoContent();
                }
                catch (DbUpdateConcurrencyException)
                {
                    return Results.Conflict(new ProblemDetails
                    {
                        Title = "Concurrency Conflict",
                        Detail = "The record was modified by another user."
                    });
                }
            })
            .WithTags("Activities")
            .Produces(204)
            .Produces(409)
            .RequireValidation();

        app.MapDelete("/api/activities/{id:guid}", async (Guid id, IActivityRepository repo, CancellationToken ct) =>
            {
                var entity = await repo.GetByIdAsync(id, ct);
                if (entity is null) return Results.NotFound();
                
                await repo.DeleteAsync(id, ct);
                await repo.SaveChangesAsync(ct);
                return Results.NoContent();
            })
            .WithTags("Activities")
            .Produces(204)
            .Produces(404);

        return app;
    }
}
