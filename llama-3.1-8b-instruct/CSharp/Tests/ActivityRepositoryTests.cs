// Tests/ActivityRepositoryTests.cs

using Moq;
using YourNamespace.Repositories;
using YourNamespace.Models;

namespace YourNamespace.Tests
{
    public class ActivityRepositoryTests
    {
        [Test]
        public async Task TestGetActivities()
        {
            // Arrange
            var mockSet = new Mock<DbSet<Activity>>();
            var mockContext = new Mock<YourDbContext>();
            mockContext.Setup(c => c.Set<Activity>()).Returns(mockSet.Object);
            var repository = new ActivityRepository(mockContext.Object);

            // Act and Assert
            await repository.Get();
            mockSet.Verify(s => s.ToList(), Times.Once());
        }

        [Test]
        public async Task TestGetActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid() };
            var mockSet = new Mock<DbSet<Activity>>();
            mockSet.Setup(s => s.Find(It.IsAny<Guid>())).Returns(activity);
            var mockContext = new Mock<YourDbContext>();
            mockContext.Setup(c => c.Set<Activity>()).Returns(mockSet.Object);
            var repository = new ActivityRepository(mockContext.Object);

            // Act and Assert
            await repository.Get(Guid.NewGuid());
            mockSet.Verify(s => s.Find(It.IsAny<Guid>()), Times.Once());
        }

        [Test]
        public async Task TestAddActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid() };
            var mockEntry = new Mock<DbEntityEntry<Activity>>();
            mockEntry.Setup(e => e.GetDatabaseValues()).Returns(new DbValues(activity));
            var mockSet = new Mock<DbSet<Activity>>();
            mockSet.Setup(s => s.Add(It.IsAny<Activity>())).Callback(() => activity.ActivityId = Guid.NewGuid());
            mockSet.Setup(s => s.Entry(It.IsAny<Activity>())).Returns(mockEntry.Object);
            var mockContext = new Mock<YourDbContext>();
            mockContext.Setup(c => c.Set<Activity>()).Returns(mockSet.Object);
            var repository = new ActivityRepository(mockContext.Object);

            // Act and Assert
            await repository.Add(activity);
            mockSet.Verify(s => s.Add(It.IsAny<Activity>()), Times.Once());
        }

        [Test]
        public async Task TestUpdateActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid() };
            var mockEntry = new Mock<DbEntityEntry<Activity>>();
            mockEntry.Setup(e => e.GetDatabaseValues()).Returns(new DbValues(activity));
            var mockSet = new Mock<DbSet<Activity>>();
            mockSet.Setup(s => s.Update(It.IsAny<Activity>()));
            mockSet.Setup(s => s.Entry(It.IsAny<Activity>())).Returns(mockEntry.Object);
            var mockContext = new Mock<YourDbContext>();
            mockContext.Setup(c => c.Set<Activity>()).Returns(mockSet.Object);
            var repository = new ActivityRepository(mockContext.Object);

            // Act and Assert
            await repository.Update(activity);
            mockSet.Verify(s => s.Update(It.IsAny<Activity>()), Times.Once());
        }

        [Test]
        public async Task TestDeleteActivity()
        {
            // Arrange
            var activity = new Activity { ActivityId = Guid.NewGuid() };
            var mockSet = new Mock<DbSet<Activity>>();
            mockSet.Setup(s => s.Find(It.IsAny<Guid>())).Returns(activity);
            var mockContext = new Mock<YourDbContext>();
            mockContext.Setup(c => c.Set<Activity>()).Returns(mockSet.Object);
            var repository = new ActivityRepository(mockContext.Object);

            // Act and Assert
            await repository.Delete(Guid.NewGuid());
            mockSet.Verify(s => s.Find(It.IsAny<Guid>()), Times.Once());
        }
    }
}
