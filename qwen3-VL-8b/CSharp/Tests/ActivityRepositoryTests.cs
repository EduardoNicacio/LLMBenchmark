// Integration Tests: ActivityRepositoryTests.cs
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using YourProject.DTOs;
using YourProject.Models;
using YourProject.Repositories;

namespace YourProject.Tests
{
    [TestFixture]
    public class ActivityRepositoryTests
    {
        private Mock<DbContext> _mockContext;
        private IActivityRepository _repository;

        [SetUp]
        public void Setup()
        {
            _mockContext = new Mock<DbContext>();
            _repository = new ActivityRepository(_mockContext.Object);
        }

        [Test]
        public async Task GetReadDtoListAsync_ReturnsDtoList()
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
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
                Tags = "tag1,tag2",
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "TestUser",
                CreatedByProgram = "TestProgram",
                UpdatedDateTime = DateTime.UtcNow,
                UpdatedByUser = "TestUser",
                UpdatedByProgram = "TestProgram"
            };

            _mockContext
                .Setup(x => x.Set<Activity>())
                .Returns(new Mock<DbSet<Activity>>().Object);

            _mockContext
                .Setup(x => x.Set<Activity>().Select(It.IsAny<System.Linq.Expressions.Expression<Func<Activity, ReadActivityDto>>>()))
                .Returns(new List<ReadActivityDto> { new ReadActivityDto { ActivityId = activity.ActivityId } }.AsQueryable());

            var result = await _repository.GetReadDtoListAsync();
            Assert.That(result, Is.Not.Empty);
            Assert.That(result.First().ActivityId, Is.EqualTo(activity.ActivityId));
        }

        [Test]
        public async Task GetByProjectIdAsync_ReturnsActivities()
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
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
                Tags = "tag1,tag2",
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "TestUser",
                CreatedByProgram = "TestProgram",
                UpdatedDateTime = DateTime.UtcNow,
                UpdatedByUser = "TestUser",
                UpdatedByProgram = "TestProgram"
            };

            _mockContext
                .Setup(x => x.Set<Activity>())
                .Returns(new Mock<DbSet<Activity>>().Object);

            _mockContext
                .Setup(x => x.Set<Activity>().Where(It.IsAny<System.Linq.Expressions.Expression<Func<Activity, bool>>>()))
                .Returns(new List<Activity> { activity }.AsQueryable());

            var result = await _repository.GetByProjectIdAsync(Guid.NewGuid());
            Assert.That(result, Is.Not.Empty);
            Assert.That(result.First().ProjectId, Is.EqualTo(activity.ProjectId));
        }

        [Test]
        public async Task GetByIdAsync_ReturnsActivity()
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
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
                Tags = "tag1,tag2",
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "TestUser",
                CreatedByProgram = "TestProgram",
                UpdatedDateTime = DateTime.UtcNow,
                UpdatedByUser = "TestUser",
                UpdatedByProgram = "TestProgram"
            };

            _mockContext
                .Setup(x => x.Set<Activity>())
                .Returns(new Mock<DbSet<Activity>>().Object);

            _mockContext
                .Setup(x => x.Set<Activity>().Find(It.IsAny<Guid>()))
                .Returns(activity);

            var result = await _repository.GetByIdAsync(activity.ActivityId);
            Assert.That(result, Is.Not.Null);
            Assert.That(result.ActivityId, Is.EqualTo(activity.ActivityId));
        }
    }
}
