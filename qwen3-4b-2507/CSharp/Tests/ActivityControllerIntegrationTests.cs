// Integration Tests: ActivityControllerIntegrationTests.cs
using Moq;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using ActivityManagement.Controllers;

namespace ActivityManagement.Tests
{
    [TestFixture]
    public class ActivityControllerIntegrationTests
    {
        private Mock<IGenericRepository<ActivityModel>> _mockRepository;
        private ActivityController _controller;

        [SetUp]
        public void Setup()
        {
            _mockRepository = new Mock<IGenericRepository<ActivityModel>>();
            _controller = new ActivityController(_mockRepository.Object);
        }

        [Test]
        public async Task Get_ReturnsOk_WhenActivitiesExist()
        {
            var activities = new List<ActivityModel>
            {
                new() { ActivityId = Guid.NewGuid(), Name = "Test" }
            };

            _mockRepository.Setup(x => x.GetAllAsync()).ReturnsAsync(activities);

            var result = await _controller.Get();

            Assert.That(result, Is.InstanceOf<OkObjectResult>());
            Assert.That(result.Value, Is.Not.Null);
        }

        [Test]
        public async Task Post_ReturnsCreated_WhenActivityIsAdded()
        {
            var dto = new CreateActivityDto
            {
                Name = "New Activity",
                ProjectId = Guid.NewGuid()
            };

            _mockRepository.Setup(x => x.AddAsync(It.IsAny<ActivityModel>()))
                .Returns(Task.CompletedTask);

            var result = await _controller.Post(dto);

            Assert.That(result, Is.InstanceOf<CreatedAtResult>());
        }

        [Test]
        public async Task Put_ReturnsNoContent_WhenActivityIsUpdated()
        {
            var dto = new UpdateActivityDto
            {
                Name = "Updated"
            };

            _mockRepository.Setup(x => x.UpdateAsync(It.IsAny<ActivityModel>()))
                .Returns(Task.CompletedTask);

            var result = await _controller.Put(Guid.NewGuid(), dto);

            Assert.That(result, Is.InstanceOf<NoContentResult>());
        }

        [Test]
        public async Task Delete_ReturnsNoContent_WhenActivityIsDeleted()
        {
            _mockRepository.Setup(x => x.DeleteAsync(It.IsAny<ActivityModel>()))
                .Returns(Task.CompletedTask);

            var result = await _controller.Delete(Guid.NewGuid());

            Assert.That(result, Is.InstanceOf<NoContentResult>());
        }
    }
}
