// File: Tests/Integration/MinimalApiIntegrationTests.cs
using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using MyApp.DTOs;
using NUnit.Framework;

namespace MyApp.Tests.Integration;

/// <summary>
/// Integration tests that spin up the real API with an in‑memory database.
/// </summary>
[TestFixture]
public class MinimalApiIntegrationTests
{
    private WebApplicationFactory<Program> _factory = null!;
    private HttpClient _client = null!;

    [SetUp]
    public void Setup()
    {
        _factory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                // Override DB to use in‑memory for tests
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<AppDbContext>(options =>
                        options.UseInMemoryDatabase("TestDb"));
                });
            });

        _client = _factory.CreateClient();
    }

    [TearDown]
    public void Teardown()
    {
        _client.Dispose();
        _factory.Dispose();
    }

    [Test]
    public async Task Post_Activity_ShouldReturnCreated()
    {
        var dto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "API Test",
            Description = "Testing POST endpoint"
        };

        var response = await _client.PostAsJsonAsync("/activities", dto);

        Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);
        var created = await response.Content.ReadFromJsonAsync<ActivityReadDto>();
        Assert.NotNull(created);
        Assert.AreEqual(dto.Name, created!.Name);
    }

    [Test]
    public async Task Get_Activities_ShouldReturnList()
    {
        // Seed one activity
        var dto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Seeded",
            Description = "Preloaded"
        };
        await _client.PostAsJsonAsync("/activities", dto);

        var response = await _client.GetAsync("/activities");
        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        var list = await response.Content.ReadFromJsonAsync<List<ActivityReadDto>>();
        Assert.NotNull(list);
        Assert.IsNotEmpty(list!);
    }

    [Test]
    public async Task Put_Activity_ShouldUpdate()
    {
        // Create
        var createDto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "To Update",
            Description = "Before"
        };
        var createdResponse = await _client.PostAsJsonAsync("/activities", createDto);
        var created = await createdResponse.Content.ReadFromJsonAsync<ActivityReadDto>();

        // Update
        var updateDto = new ActivityUpdateDto
        {
            ActivityId = created!.ActivityId,
            ProjectId = created.ProjectId,
            ProjectMemberId = created.ProjectMemberId,
            Name = "Updated",
            Description = "After",
            SystemTimestamp = created.SystemTimestamp
        };

        var putResponse = await _client.PutAsJsonAsync($"/activities/{created.ActivityId}", updateDto);
        Assert.AreEqual(HttpStatusCode.NoContent, putResponse.StatusCode);

        // Verify
        var getResp = await _client.GetAsync($"/activities/{created.ActivityId}");
        var updated = await getResp.Content.ReadFromJsonAsync<ActivityReadDto>();
        Assert.AreEqual("Updated", updated!.Name);
    }

    [Test]
    public async Task Delete_Activity_ShouldSoftDelete()
    {
        // Create
        var createDto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "To Delete",
            Description = "Will be deleted"
        };
        var createdResponse = await _client.PostAsJsonAsync("/activities", createDto);
        var created = await createdResponse.Content.ReadFromJsonAsync<ActivityReadDto>();

        // Delete
        var deleteResp = await _client.DeleteAsync($"/activities/{created!.ActivityId}");
        Assert.AreEqual(HttpStatusCode.NoContent, deleteResp.StatusCode);

        // Verify soft delete by checking status code 404 for GET
        var getResp = await _client.GetAsync($"/activities/{created.ActivityId}");
        Assert.AreEqual(HttpStatusCode.NotFound, getResp.StatusCode);
    }
}
