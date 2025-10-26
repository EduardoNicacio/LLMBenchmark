using Moq;
using NUnit.Framework;

namespace ActivityManagement.Tests
{
    [TestFixture]
    public class RepositoryTests
    {
        private Mock<ApplicationDbContext> _contextMock;
        private IActivityRepository _repository;

        [SetUp]
        public void Setup()
        {
            _contextMock = new Mock<ApplicationDbContext>();
            _repository = new ActivityRepository(_contextMock.Object);
        }

        [Test]
        public async Task GetAllAsync_ShouldReturnAllActivities()
        {
            var activities = new List<Activity>
            {
                new Activity { Name = "Activity 1" },
                new Activity { Name = "Activity 2" }
            };

            _contextMock.Setup(c => c.Activities).ReturnsDbSet(activities);

            var result = await _repository.GetAllAsync();

            Assert.AreEqual(2, result.Count);
        }

        [Test]
        public async Task AddAsync_ShouldAddNewActivity()
        {
            var activityDto = new CreateActivityDto
            {
                Name = "New Activity",
                Description = "This is a new activity."
            };

            var activity = new Activity
            {
                Name = activityDto.Name,
                Description = activityDto.Description
            };

            _contextMock.Setup(c => c.Activities.AddAsync(activity, It.IsAny<CancellationToken>()))
                .Returns(Task.FromResult(EntityEntry<Activity>.Extensions.FromEntityEntry(activity)));

            await _repository.AddAsync(activity);

            _contextMock.Verify(c => c.SaveChangesAsync(It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
