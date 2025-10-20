using Microsoft.AspNetCore.Mvc;
using Moq;
using YourNamespace.Repositories;
using YourNamespace.Models.DTOs;
using YourNamespace.Endpoints;
using Xunit;
using System.Threading.Tasks;

namespace YourNamespace.Tests.IntegrationTests
{
    [Collection("Sequential")]
    public class ActivityIntegrationTests
    {
        private readonly Mock<IActivityRepository> _mockRepository;
        private readonly ActivityController _controller;

        public ActivityIntegrationTests()
        {
            _mockRepository = new Mock<IActivityRepository>();
            _controller = new ActivityController(_mockRepository.Object);
        }

        [Fact]
        public async Task CreateActivity_Returns_201_When_Valid_Data()
        {
            // Arrange
            var createDto = new CreateActivityDto
            {
                Name = "Test Activity",
                Description = "Test description",
                ActiveFlag = 1,
                SystemDeleteFlag = 'N'
            };

            // Act
            var result = await _controller.CreateActivity(createDto);

            // Assert
            var okResult = Assert.IsType<CreatedAtActionResult>(result);
            var activityId = okResult.Value.Id;
            Assert.NotNull(activityId);
        }

        [Fact]
        public async Task UpdateActivity_Updates_Existing_Record()
        {
            // Arrange
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                Name = "Existing Activity",
                ActiveFlag = 1
            };

            _mockRepository.Setup(repo => repo.GetByIdAsync(It.IsAny<Guid>()))
                .ReturnsAsync(activity);

            // Act
            var updateDto = new UpdateActivityDto
            {
                ActiveFlag = 0
            };
            var result = await _controller.UpdateActivity(activity.ActivityId, updateDto);

            // Assert
            Assert.IsType<NoContentResult>(result);
            Assert.Equal(0, activity.ActiveFlag);
        }
    }
}
