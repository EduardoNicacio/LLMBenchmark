using ActivityApp.Repositories;
using ActivityApp.Api;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddDbContext<ActivityDbContext>();
builder.Services.AddScoped<IRepository<Activity>, ActivityRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

// Map Razor Pages
app.MapRazorPages();

// Map Minimal API
app.MapActivityEndpoints();

app.Run();
