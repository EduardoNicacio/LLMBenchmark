using ActivityManagement.Dtos;
using ActivityManagement.Models;
using ActivityManagement.Repositories;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<IActivityRepository, ActivityRepository>();

var app = builder.Build();

app.MapGet("/api/activities", async ([FromServices] IActivityRepository repository) =>
{
    var activities = await repository.GetAllAsync();
    return Results.Ok(activities);
});

app.MapPost("/api/activities", async ([FromBody] CreateActivityDto dto, [FromServices] IActivityRepository repository) =>
{
    if (!ModelState.IsValid)
        return Results.BadRequest(ModelState);

    var activity = new Activity
    {
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
        SystemDeleteFlag = dto.SystemDeleteFlag,
        CreatedDateTime = DateTime.UtcNow,
        CreatedByUser = "System",
        CreatedByProgram = "API"
    };

    await repository.AddAsync(activity);
    return Results.Created($"/api/activities/{activity.ActivityId}", activity);
});

app.MapPut("/api/activities/{id:guid}", async (Guid id, [FromBody] UpdateActivityDto dto, [FromServices] IActivityRepository repository) =>
{
    if (!ModelState.IsValid)
        return Results.BadRequest(ModelState);

    var activity = await repository.GetByIdAsync(id);
    if (activity == null)
        return Results.NotFound();

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
    activity.UpdatedByUser = "System";
    activity.UpdatedByProgram = "API";

    repository.Update(activity);
    return Results.NoContent();
});

app.MapDelete("/api/activities/{id:guid}", async (Guid id, [FromServices] IActivityRepository repository) =>
{
    var activity = await repository.GetByIdAsync(id);
    if (activity == null)
        return Results.NotFound();

    repository.Delete(activity);
    return Results.NoContent();
});

app.Run();
