using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Moq;
using NUnit.Framework;
using YourApp.Infrastructure.Data;
using YourApp.Web;

namespace YourApp.Tests.Integration
{
    [TestFixture]
    public class ActivityIntegrationTests : IDisposable
    {
        private WebApplicationFactory<Program> _factory;
        private DbContextOptions<AppDbContext> _options;

        [OneTimeSetUp]
        public void SetUp()
        {
            // In‑memory DB configuration
            _options = new DbContextOptionsBuilder<AppDbContext>()
                .UseInMemoryDatabase("ActivitiesTest")
                .EnableSensitiveDataLogging()
                .Options;

            _factory = new WebApplicationFactory<Program>();
            var builder = _factory.WebApplication.Builder();
            builder.ConfigureServices((IServiceCollection services, IConfiguration config) =>
            {
                services.AddDbContext<AppDbContext>(_options);
                services.AddScoped<IActivityRepository, ActivityRepository>();
                // Add other required services (e.g., MVC, Razor Pages)
                services.AddRazorPages();
                services.AddEndpointsApiExplorer();
                services.AddProblemDetails();
            });
            _factory.WebApplication = builder.Build();

            // Apply migrations (in‑memory has none) and seed minimal data
        }

        [OneTimeTearDown]
        public void TearDown()
        {
            _factory.Dispose();
        }

        [SetUp]
        public void SetUpEachTest()
        {
            // Reset in‑memory DB state before each test
            using var ctx = new AppDbContext(_options);
            ctx.Database.Reset();
        }

        [Test]
        public async Task Repository_AddAndGetById_RoundTripWorks()
        {
            // Arrange
            var repo = new ActivityRepository(new AppDbContext(_options));
            var activity = new Activity
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "IntTest",
                Description = "Integration test",
                ActiveFlag = 1,
                SystemDeleteFlag = "N",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "system",
                CreatedByProgram = "test"
            };

            // Act
            await repo.AddAsync(activity);
            await repo.SaveChangesAsync();

            var fetched = await repo.GetByIdAsync(activity.ActivityId);
            // Assert
            fetched.Should().NotBeNull();
            fetched!.Name.Should().Be("IntTest");
        }

        [Test]
        public async Task Repository_DeletePerformsSoftDelete()
        {
            // Arrange
            var repo = new ActivityRepository(new AppDbContext(_options));
            var activity = new Activity
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "ToDelete",
                Description = "Will be soft‑deleted",
                ActiveFlag = 1,
                SystemDeleteFlag = "N",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "system",
                CreatedByProgram = "test"
            };
            await repo.AddAsync(activity);
            await repo.SaveChangesAsync();

            // Act
            await repo.DeleteAsync(activity.ActivityId);

            var after = await repo.GetByIdAsync(activity.ActivityId);
            // Assert
            after.Should().NotBeNull();
            after!.SystemDeleteFlag.Should().Be("Y");
        }

        [Test]
        public async Task MinimalApi_CreateEndpoint_Returns201()
        {
            // Arrange
            var client = _factory.CreateClient();

            var payload = new
            {
                projectId = Guid.NewGuid(),
                projectMemberId = Guid.NewGuid(),
                name = "API Test",
                description = "Create via API",
                activeFlag = 1
            };

            // Act
            var response = await client.PostJson<ActivityCreateDto>("/api/activities", payload);

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.Created);
        }

        public void Dispose()
        {
            _factory.Dispose();
        }
    }
}
