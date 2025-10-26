// File: Program.cs (Minimal API)
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using MyApp.Data;
using MyApp.DTOs;
using MyApp.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<IActivityRepository, ActivityRepository>();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Middleware
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/activities", async (IActivityRepository repo) =>
    await repo.GetAllAsync())
   .WithName("GetAllActivities")
   .Produces<IEnumerable<ActivityReadDto>>(StatusCodes.Status200OK);

app.MapGet("/activities/{id:guid}", async (Guid id, IActivityRepository repo) =>
{
    var activity = await repo.GetAsync(id);
    return activity == null ? Results.NotFound() : Results.Ok(activity);
})
   .WithName("GetActivityById")
   .Produces<ActivityReadDto>(StatusCodes.Status200OK)
   .Produces(StatusCodes.Status404NotFound);

app.MapPost("/activities", async (ActivityCreateDto dto, IActivityRepository repo) =>
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
        ActiveFlag = 1, // default active
        SystemDeleteFlag = 'N',
        CreatedDateTime = DateTime.UtcNow,
        CreatedByUser = "system",      // replace with auth context
        CreatedByProgram = "MinimalAPI"
    };

    await repo.AddAsync(activity);
    return Results.Created($"/activities/{activity.ActivityId}", activity);
})
   .WithName("CreateActivity")
   .Produces<ActivityReadDto>(StatusCodes.Status201Created)
   .Accepts<ActivityCreateDto>("application/json");

app.MapPut("/activities/{id:guid}", async (Guid id, ActivityUpdateDto dto, IActivityRepository repo) =>
{
    if (id != dto.ActivityId)
        return Results.BadRequest("ID mismatch.");

    var existing = await repo.GetAsync(id);
    if (existing == null)
        return Results.NotFound();

    // Map updated fields
    existing.ProjectId = dto.ProjectId;
    existing.ProjectMemberId = dto.ProjectMemberId;
    existing.Name = dto.Name;
    existing.Description = dto.Description;
    existing.StartDate = dto.StartDate;
    existing.TargetDate = dto.TargetDate;
    existing.EndDate = dto.EndDate;
    existing.ProgressStatus = dto.ProgressStatus;
    existing.ActivityPoints = dto.ActivityPoints;
    existing.Priority = dto.Priority;
    existing.Risk = dto.Risk;
    existing.Tags = dto.Tags;

    // Concurrency handling
    try
    {
        repo.Update(existing);
    }
    catch (DbUpdateConcurrencyException)
    {
        return Results.Conflict("The activity has been modified by another user.");
    }

    return Results.NoContent();
})
   .WithName("UpdateActivity")
   .Produces(StatusCodes.Status204NoContent)
   .Produces(StatusCodes.Status400BadRequest)
   .Produces(StatusCodes.Status404NotFound);

app.MapDelete("/activities/{id:guid}", async (Guid id, IActivityRepository repo) =>
{
    var activity = await repo.GetAsync(id);
    if (activity == null)
        return Results.NotFound();

    // Soft delete – set flags instead of hard delete
    activity.ActiveFlag = 0;
    activity.SystemDeleteFlag = 'Y';
    repo.Update(activity);

    return Results.NoContent();
})
   .WithName("DeleteActivity")
   .Produces(StatusCodes.Status204NoContent)
   .Produces(StatusCodes.Status404NotFound);

app.Run();
