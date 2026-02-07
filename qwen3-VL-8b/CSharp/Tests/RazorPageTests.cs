// Integration Tests: RazorPageTests.cs
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.RazorPages.Testing;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using Microsoft.EntityFrameworkCore;
using YourProject.Models;
using YourProject.Repositories;

namespace YourProject.Tests
{
    [TestFixture]
    public class RazorPageTests
    {
        private WebApplicationFactory<Program> _factory;
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

            _factory = new WebApplicationFactory<Program>();
            _client = _factory.CreateClient();
        }

        [Test]
        public async Task CreatePage_ReturnsSuccess()
        {
            var model = new CreateActivityViewModel
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

            var page = new CreateModel(_repository);
            page.Model = model;

            var result = await page.OnPostAsync();
            Assert.That(result, Is.Not.Null);
            Assert.That(result, Is.InstanceOf<IActionResult>());
        }

        [Test]
        public async Task EditPage_ReturnsSuccess()
        {
            var model = new UpdateActivityViewModel
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

            var page = new EditModel(_repository);
            page.Model = model;

            var result = await page.OnPostAsync(Guid.NewGuid());
            Assert.That(result, Is.Not.Null);
            Assert.That(result, Is.InstanceOf<IActionResult>());
        }

        [Test]
        public async Task DeletePage_ReturnsSuccess()
        {
            var page = new DeleteModel(_repository);
            var result = await page.OnPostAsync(Guid.NewGuid());
            Assert.That(result, Is.Not.Null);
            Assert.That(result, Is.InstanceOf<IActionResult>());
        }
    }
}
