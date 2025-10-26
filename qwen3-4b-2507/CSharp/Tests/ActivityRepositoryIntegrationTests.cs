// Integration Tests: ActivityRepositoryIntegrationTests.cs
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ActivityManagement.Tests
{
    [TestFixture]
    public class ActivityRepositoryIntegrationTests
    {
        private Mock<ApplicationDbContext> _mockContext;
        private ActivityRepository _repository;

        [SetUp]
        public void Setup()
        {
            _mockContext = new Mock<ApplicationDbContext>();
            _repository = new ActivityRepository(_mockContext.Object);
        }

        [Test]
        public async Task GetByIdAsync_ReturnsActivity_WhenIdExists()
        {
            var activity = new ActivityModel
            {
                ActivityId = Guid.NewGuid(),
                Name = "Test",
                ProjectId = Guid.NewGuid()
            };

            _mockContext.Setup(x => x.Activities.FindAsync(It.IsAny<Guid>()))
                .ReturnsAsync(activity);

            var result = await _repository.GetByIdAsync(activity.ActivityId);

            Assert.That(result, Is.Not.Null);
            Assert.That(result.Name, Is.EqualTo("Test"));
        }

        [Test]
        public async Task GetAllAsync_ReturnsAllActivities()
        {
            var activities = new List<ActivityModel>
            {
                new() { ActivityId = Guid.NewGuid(), Name = "A" },
                new() { ActivityId = Guid.NewGuid(), Name = "B" }
            };

            _mockContext.Setup(x => x.Activities.ToListAsync())
                .ReturnsAsync(activities);

            var result = await _repository.GetAllAsync();

            Assert.That(result, Is.Not.Null);
            Assert.That(result.Count, Is.EqualTo(2));
        }

        [Test]
        public async Task AddAsync_SavesEntityToDatabase()
        {
            var activity = new ActivityModel
            {
                ActivityId = Guid.NewGuid(),
                Name = "New Activity"
            };

            _mockContext.Setup(x => x.Activities.AddAsync(It.IsAny<ActivityModel>()))
                .Returns(Task.CompletedTask);

            await _repository.AddAsync(activity);

            _mockContext.Verify(x => x.SaveChangesAsync(), Times.Once);
        }

        [Test]
        public async Task UpdateAsync_UpdatesEntityInDatabase()
        {
            var activity = new ActivityModel
            {
                ActivityId = Guid.NewGuid(),
                Name = "Old"
            };

            _mockContext.Setup(x => x.Activities.Update(It.IsAny<ActivityModel>()))
                .Returns(Task.CompletedTask);

            await _repository.UpdateAsync(activity);

            _mockContext.Verify(x => x.SaveChangesAsync(), Times.Once);
        }

        [Test]
        public async Task DeleteAsync_RemovesEntityFromDatabase()
        {
            var activity = new ActivityModel
            {
                ActivityId = Guid.NewGuid()
            };

            _mockContext.Setup(x => x.Activities.Remove(It.IsAny<ActivityModel>()))
                .Returns(Task.CompletedTask);

            await _repository.DeleteAsync(activity);

            _mockContext.Verify(x => x.SaveChangesAsync(), Times.Once);
        }
    }
}
