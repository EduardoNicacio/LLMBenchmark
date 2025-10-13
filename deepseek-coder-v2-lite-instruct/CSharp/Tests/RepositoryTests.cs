using Moq;
using NUnit.Framework;
using YourNamespace.Repositories;
using YourNamespace.Models;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System;

namespace YourNamespace.Tests
{
    [TestFixture]
    public class RepositoryTests
    {
        private Mock<DbContext> _mockContext;
        private ActivityRepository _activityRepo;

        [SetUp]
        public void SetUp()
        {
            _mockContext = new Mock<DbContext>();
            var mockDbSet = new Mock<DbSet<Activity>>();
            _mockContext.Setup(x => x.Set<Activity>()).Returns(mockDbSet.Object);
            _activityRepo = new ActivityRepository(_mockContext.Object);
        }

        [Test]
        public async Task GetByIdAsync_ShouldReturnCorrectActivity()
        {
            var activityId = Guid.NewGuid();
            var expectedActivity = new Activity { ActivityId = activityId };
            _mockContext.Setup(x => x.Set<Activity>().FindAsync(activityId)).ReturnsAsync(expectedActivity);

            var result = await _activityRepo.GetByIdAsync(activityId);

            Assert.AreEqual(expectedActivity, result);
        }
    }
}
