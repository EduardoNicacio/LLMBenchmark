using ActivityTracker.Models;
using ActivityTracker.Repository;
using Moq;
using Moq.EntityFrameworkCore;
using NUnit.Framework;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace ActivityTracker.Tests
{
    [TestFixture]
    public class RepositoryTests
    {
        private Mock<ActivityTrackerDbContext> _mockContext;
        private IActivityRepository _repository;

        [SetUp]
        public void Setup()
        {
            _mockContext = new Mock<ActivityTrackerDbContext>();
            _repository = new ActivityRepository(_mockContext.Object);
        }

        [Test]
        public async Task GetAllAsync_ShouldReturnAllActivities()
        {
            // Arrange
            var activities = new[]
            {
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 1" },
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 2" }
            };

            _mockContext.Setup(c => c.Activities).ReturnsDbSet(activities);

            // Act
            var result = await _repository.GetAllAsync();

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(2, result.Count());
        }

        [Test]
        public async Task AddAsync_ShouldAddActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid(), Name = "New Activity" };

            // Act
            await _repository.AddAsync(activity);

            // Assert
            _mockContext.Verify(c => c.Activities.AddAsync(activity), Times.Once);
            _mockContext.Verify(c => c.SaveChangesAsync(default), Times.Once);
        }
    }
}
