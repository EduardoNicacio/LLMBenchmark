// File: Tests/Integration/RazorPagesIntegrationTests.cs
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;
using NUnit.Framework;

namespace MyApp.Tests.Integration;

/// <summary>
/// Integration tests that exercise Razor Page handlers using the TestServer.
/// </summary>
[TestFixture]
public class RazorPagesIntegrationTests
{
    private WebApplicationFactory<Program> _factory = null!;
    private HttpClient _client = null!;

    [SetUp]
    public void Setup()
    {
        _factory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<AppDbContext>(options =>
                        options.UseInMemoryDatabase("RazorTestDb"));
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
    public async Task IndexPage_ShouldReturnActivitiesList()
    {
        // Seed an activity via API
        var dto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Razor Test",
            Description = "Testing Razor Page index"
        };
        await _client.PostAsJsonAsync("/activities", dto);

        // Request the Index page
        var response = await _client.GetAsync("/Activities/Index");
        Assert.AreEqual(System.Net.HttpStatusCode.OK, response.StatusCode);
        var content = await response.Content.ReadAsStringAsync();
        Assert.IsTrue(content.Contains("Razor Test"));
    }

    [Test]
    public async Task CreatePage_ShouldCreateActivity()
    {
        // POST form data to the create page
        var formData = new Dictionary<string, string>
        {
            { "Activity.ProjectId", Guid.NewGuid().ToString() },
            { "Activity.ProjectMemberId", Guid.NewGuid().ToString() },
            { "Activity.Name", "Page Create" },
            { "Activity.Description", "Created via Razor Page" }
        };

        var response = await _client.PostAsync("/Activities/Create",
            new FormUrlEncodedContent(formData));

        // Should redirect to Index
        Assert.AreEqual(System.Net.HttpStatusCode.Redirect, response.StatusCode);
        Assert.IsTrue(response.Headers.Location.ToString().Contains("Index"));

        // Verify record exists
        var indexResp = await _client.GetAsync("/Activities/Index");
        var content = await indexResp.Content.ReadAsStringAsync();
        Assert.IsTrue(content.Contains("Page Create"));
    }

    [Test]
    public async Task EditPage_ShouldUpdateActivity()
    {
        // Seed activity
        var createDto = new ActivityCreateDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Original",
            Description = "Before edit"
        };
        var createdResp = await _client.PostAsJsonAsync("/activities", createDto);
        var created = await createdResp.Content.ReadFromJsonAsync<ActivityReadDto>();

        // Get Edit page to retrieve the hidden timestamp
        var editPageResp = await _client.GetAsync($"/Activities/Edit/{created!.ActivityId}");
        var editContent = await editPageResp.Content.ReadAsStringAsync();
        Assert.IsTrue(editContent.Contains("Original"));

        // Extract SystemTimestamp value (simplified extraction for demo purposes)
        var timestampMatch = Regex.Match(editContent, @"name=""Activity\.SystemTimestamp"" value=""([^""]+)""");
        string? base64Ts = timestampMatch.Groups[1].Value;
        byte[] tsBytes = Convert.FromBase64String(base64Ts);

        // Submit updated data
        var formData = new Dictionary<string, string>
        {
            { "Activity.ActivityId", created.ActivityId.ToString() },
            { "Activity.ProjectId", created.ProjectId.ToString() },
            { "Activity.ProjectMemberId", created.ProjectMemberId.ToString() },
            { "Activity.Name", "Updated via Page" },
            { "Activity.Description", "After edit" },
            { "Activity.SystemTimestamp", base64Ts }
        };

        var postResp = await _client.PostAsync($"/Activities/Edit/{created.ActivityId}",
            new FormUrlEncodedContent(formData));

        Assert.AreEqual(System.Net.HttpStatusCode.Redirect, postResp.StatusCode);

        // Verify update
        var detailsResp = await _client.GetAsync($"/Activities/Details/{created.ActivityId}");
        var detailsContent = await detailsResp.Content.ReadAsStringAsync();
        Assert.IsTrue(detailsContent.Contains("Updated via Page"));
    }
}
