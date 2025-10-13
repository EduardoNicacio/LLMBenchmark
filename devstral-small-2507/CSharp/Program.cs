using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System.Threading.Tasks;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/api/activities", async (IActivityRepository repository) =>
{
    var activities = await repository.GetAllAsync();
    return Results.Ok(activities);
});

app.MapGet("/api/activities/{id}", async (Guid id, IActivityRepository repository) =>
{
    var activity = await repository.GetByIdAsync(id);
    if (activity == null)
    {
        return Results.NotFound();
    }
    return Results.Ok(activity);
});

app.MapPost("/api/activities", async (CreateActivityDto createDto, IActivityRepository repository) =>
{
    var activity = new Activity
    {
        // Map properties from CreateDto to Activity
        // ...
        CreatedDateTime = DateTime.UtcNow,
        ActiveFlag = true,
        SystemDeleteFlag = 'N'
    };

    await repository.AddAsync(activity);
    return Results.Created($"/api/activities/{activity.ActivityId}", activity);
});

app.MapPut("/api/activities/{id}", async (Guid id, UpdateActivityDto updateDto, IActivityRepository repository) =>
{
    var activity = await repository.GetByIdAsync(id);
    if (activity == null)
    {
        return Results.NotFound();
    }

    // Map properties from UpdateDto to Activity
    // ...

    activity.UpdatedDateTime = DateTime.UtcNow;
    repository.Update(activity);
    return Results.Ok(activity);
});

app.MapDelete("/api/activities/{id}", async (Guid id, IActivityRepository repository) =>
{
    var activity = await repository.GetByIdAsync(id);
    if (activity == null)
    {
        return Results.NotFound();
    }

    // Soft delete
    activity.ActiveFlag = false;
    activity.SystemDeleteFlag = 'Y';
    repository.Update(activity);

    return Results.NoContent();
});

app.Run();
