// Integration Tests: MinimalApiTests.cs
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using YourProject.Controllers;
using YourProject.Repositories;

namespace YourProject.Tests
{
    [TestFixture]
    public class MinimalApiTests
    {
        private HttpClient _client;
        private Mock<DbContext> _mockContext;
        private IActivityRepository _repository;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<YourProjectDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDatabase")
                .Options;

            var context = new YourProjectDbContext(options);
            _mockContext = new Mock<DbContext>(context);
            _repository = new ActivityRepository(_mockContext.Object);

            var app = new WebApplication(0);
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            _client = app.CreateClient();
        }

        [Test]
        public async Task GetActivities_ReturnsOk()
        {
            var response = await _client.GetAsync("/api/activity");
            Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.OK));
        }

        [Test]
        public async Task GetActivityById_ReturnsOk()
        {
            var response = await _client.GetAsync("/api/activity/00000000-0000-0000-0000-000000000000");
            Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.NotFound));
        }

        [Test]
        public async Task CreateActivity_ReturnsCreatedAt()
        {
            var activity = new CreateActivityDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Test Description",
                StartDate = DateTime.Now,
                TargetDate = DateTime.Now.AddDays(1),
                EndDate = DateTime.Now.AddDays(2),
                ProgressStatus = 50,
                ActivityPoints = 100,
                Priority = 3,
                Risk = 2,
                Tags = "tag1,tag2"
            };

            var content = new StringContent(System.Text.Json.JsonSerializer.Serialize(activity), System.Text.Encoding.UTF8, "application/json");
            var response = await _client.PostAsync("/api/activity", content);
            Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.Created));
        }

        [Test]
        public async Task UpdateActivity_ReturnsNoContent()
        {
            var activity = new UpdateActivityDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Test Description",
                StartDate = DateTime.Now,
                TargetDate = DateTime.Now.AddDays(1),
                EndDate = DateTime.Now.AddDays(2),
                ProgressStatus = 50,
                ActivityPoints = 100,
                Priority = 3,
                Risk = 2,
                Tags = "tag1,tag2"
            };

            var content = new StringContent(System.Text.Json.JsonSerializer.Serialize(activity), System.Text.Encoding.UTF8, "application/json");
            var response = await _client.PutAsync("/api/activity/00000000-0000-0000-0000-000000000000", content);
            Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.NoContent));
        }

        [Test]
        public async Task DeleteActivity_ReturnsNoContent()
        {
            var response = await _client.DeleteAsync("/api/activity/00000000-0000-0000-0000-000000000000");
            Assert.That(response.StatusCode, Is.EqualTo(HttpStatusCode.NoContent));
        }
    }
}
