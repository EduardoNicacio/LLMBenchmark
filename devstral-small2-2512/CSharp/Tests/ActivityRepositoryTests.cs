using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Moq;
using NUnit.Framework;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Models;

namespace ProjectManagement.Tests.Integration.Repositories
{
    [TestFixture]
    public class ActivityRepositoryTests
    {
        private Mock<DbSet<Activity>> _mockSet;
        private Mock<ApplicationDbContext> _mockContext;
        private IActivityRepository _repository;

        [SetUp]
        public void SetUp()
        {
            _mockSet = new Mock<DbSet<Activity>>();
            _mockContext = new Mock<ApplicationDbContext>();
            _mockContext.Setup(m => m.Activities).Returns(_mockSet.Object);

            _repository = new ActivityRepository(_mockContext.Object);
        }

        [Test]
        public async Task GetAllAsync_WhenCalled_ShouldReturnActivities()
        {
            // Arrange
            var activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 1", ActiveFlag = true },
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 2", ActiveFlag = false }
            }.AsQueryable();

            _mockSet.As<IQueryable<Activity>>().Setup(m => m.Provider).Returns(activities.Provider);
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.Expression).Returns(activities.Expression);
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.GetEnumerator()).Returns(activities.GetEnumerator());
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.GetAsyncEnumerator(default)).Returns(activities.GetAsyncEnumerator());

            // Act
            var result = await _repository.GetAllAsync();

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.Count(), Is.EqualTo(2));
        }

        [Test]
        public async Task GetByIdAsync_WhenCalledWithValidId_ShouldReturnActivity()
        {
            // Arrange
            var activityId = Guid.NewGuid();
            var activity = new Activity { ActivityId = activityId, Name = "Test Activity" };

            _mockSet.Setup(m => m.FindAsync(activityId)).ReturnsAsync(activity);

            // Act
            var result = await _repository.GetByIdAsync(activityId);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.ActivityId, Is.EqualTo(activityId));
        }

        [Test]
        public async Task AddAsync_WhenCalled_ShouldAddActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid(), Name = "New Activity" };

            _mockSet.Setup(m => m.AddAsync(activity, default)).Returns(Task.CompletedTask);
            _mockContext.Setup(m => m.SaveChangesAsync(default)).ReturnsAsync(1);

            // Act
            await _repository.AddAsync(activity);

            // Assert
            _mockSet.Verify(m => m.AddAsync(activity, default), Times.Once);
            _mockContext.Verify(m => m.SaveChangesAsync(default), Times.Once);
        }

        [Test]
        public void Update_WhenCalled_ShouldUpdateActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid(), Name = "Updated Activity" };

            // Act
            _repository.Update(activity);

            // Assert
            _mockSet.Verify(m => m.Update(activity), Times.Once);
            _mockContext.Verify(m => m.SaveChanges(), Times.Once);
        }

        [Test]
        public void Remove_WhenCalled_ShouldRemoveActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid() };

            // Act
            _repository.Remove(activity);

            // Assert
            _mockSet.Verify(m => m.Remove(activity), Times.Once);
            _mockContext.Verify(m => m.SaveChanges(), Times.Once);
        }

        [Test]
        public async Task GetActivitiesByProjectIdAsync_WhenCalled_ShouldReturnFilteredActivities()
        {
            // Arrange
            var projectId = Guid.NewGuid();
            var activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid(), ProjectId = projectId, Name = "Project Activity", SystemDeleteFlag = "N" },
                new Activity { ActivityId = Guid.NewGuid(), ProjectId = Guid.NewGuid(), Name = "Other Activity", SystemDeleteFlag = "N" }
            }.AsQueryable();

            _mockSet.As<IQueryable<Activity>>().Setup(m => m.Provider).Returns(activities.Provider);
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.Expression).Returns(activities.Expression);
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.GetEnumerator()).Returns(activities.GetEnumerator());
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.GetAsyncEnumerator(default)).Returns(activities.GetAsyncEnumerator());

            // Act
            var result = await _repository.GetActivitiesByProjectIdAsync(projectId);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.Count(), Is.EqualTo(1));
            Assert.That(result.First().Name, Is.EqualTo("Project Activity"));
        }

        [Test]
        public async Task GetActiveActivitiesAsync_WhenCalled_ShouldReturnOnlyActiveActivities()
        {
            // Arrange
            var activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid(), Name = "Active", ActiveFlag = true, SystemDeleteFlag = "N" },
                new Activity { ActivityId = Guid.NewGuid(), Name = "Inactive", ActiveFlag = false, SystemDeleteFlag = "N" }
            }.AsQueryable();

            _mockSet.As<IQueryable<Activity>>().Setup(m => m.Provider).Returns(activities.Provider);
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.Expression).Returns(activities.Expression);
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.GetEnumerator()).Returns(activities.GetEnumerator());
            _mockSet.As<IQueryable<Activity>>().Setup(m => m.GetAsyncEnumerator(default)).Returns(activities.GetAsyncEnumerator());

            // Act
            var result = await _repository.GetActiveActivitiesAsync();

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.Count(), Is.EqualTo(1));
            Assert.That(result.First().Name, Is.EqualTo("Active"));
        }
    }
}
