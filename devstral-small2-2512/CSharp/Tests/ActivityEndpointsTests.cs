using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Moq;
using NUnit.Framework;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Dtos;
using ProjectManagement.Models;

namespace ProjectManagement.Tests.Integration.Api
{
    [TestFixture]
    public class ActivityEndpointsTests
    {
        private Mock<IActivityRepository> _mockRepository;
        private List<Activity> _activities;

        [SetUp]
        public void SetUp()
        {
            _mockRepository = new Mock<IActivityRepository>();
            _activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 1", ActiveFlag = true },
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 2", ActiveFlag = false }
            };

            _mockRepository.Setup(m => m.GetAllAsync()).ReturnsAsync(_activities);
        }

        [Test]
        public async Task GetAll_WhenCalled_ShouldReturnActivities()
        {
            // Arrange
            var endpoint = new ActivityEndpoints();

            // Act
            var result = await endpoint.GetAll(_mockRepository.Object);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.StatusCode, Is.EqualTo(200));
        }

        [Test]
        public async Task GetById_WhenCalledWithValidId_ShouldReturnActivity()
        {
            // Arrange
            var activityId = _activities[0].ActivityId;
            var endpoint = new ActivityEndpoints();

            _mockRepository.Setup(m => m.GetByIdAsync(activityId)).ReturnsAsync(_activities[0]);

            // Act
            var result = await endpoint.GetById(activityId, _mockRepository.Object);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.StatusCode, Is.EqualTo(200));
        }

        [Test]
        public async Task GetById_WhenCalledWithInvalidId_ShouldReturnNotFound()
        {
            // Arrange
            var invalidId = Guid.NewGuid();
            var endpoint = new ActivityEndpoints();

            _mockRepository.Setup(m => m.GetByIdAsync(invalidId)).ReturnsAsync((Activity)null);

            // Act
            var result = await endpoint.GetById(invalidId, _mockRepository.Object);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.StatusCode, Is.EqualTo(404));
        }

        [Test]
        public async Task Create_WhenCalledWithValidDto_ShouldReturnCreated()
        {
            // Arrange
            var dto = new ActivityCreateDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "New Activity",
                Description = "Description"
            };

            var endpoint = new ActivityEndpoints();
            _mockRepository.Setup(m => m.AddAsync(It.IsAny<Activity>())).Returns(Task.CompletedTask);

            // Act
            var result = await endpoint.Create(dto, _mockRepository.Object);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.StatusCode, Is.EqualTo(201));
        }

        [Test]
        public async Task Update_WhenCalledWithValidDto_ShouldReturnNoContent()
        {
            // Arrange
            var activityId = _activities[0].ActivityId;
            var dto = new ActivityUpdateDto
            {
                ActivityId = activityId,
                Name = "Updated Activity",
                Description = "Updated description"
            };

            var endpoint = new ActivityEndpoints();
            _mockRepository.Setup(m => m.GetByIdAsync(activityId)).ReturnsAsync(_activities[0]);
            _mockRepository.Setup(m => m.Update(It.IsAny<Activity>())).Callback(() =>
            {
                // Update the activity in memory
                _activities[0].Name = dto.Name;
                _activities[0].Description = dto.Description;
            });

            // Act
            var result = await endpoint.Update(activityId, dto, _mockRepository.Object);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.StatusCode, Is.EqualTo(204));
        }

        [Test]
        public async Task Delete_WhenCalledWithValidId_ShouldReturnNoContent()
        {
            // Arrange
            var activityId = _activities[0].ActivityId;
            var endpoint = new ActivityEndpoints();

            _mockRepository.Setup(m => m.GetByIdAsync(activityId)).ReturnsAsync(_activities[0]);
            _mockRepository.Setup(m => m.Update(It.IsAny<Activity>())).Callback(() =>
            {
                // Mark as deleted in memory
                _activities[0].SystemDeleteFlag = "Y";
            });

            // Act
            var result = await endpoint.Delete(activityId, _mockRepository.Object);

            // Assert
            Assert.That(result, Is.Not.Null);
            Assert.That(result.StatusCode, Is.EqualTo(204));
        }
    }
}
