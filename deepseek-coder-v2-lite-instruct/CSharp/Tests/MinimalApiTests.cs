using Moq;
using NUnit.Framework;
using YourNamespace.MinimalApi;
using YourNamespace.Repositories;
using YourNamespace.DTOs;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using System;

namespace YourNamespace.Tests
{
    [TestFixture]
    public class MinimalApiTests
    {
        private Mock<ActivityRepository> _mockRepo;
        private ActivitiesController _controller;

        [SetUp]
        public void SetUp()
        {
            _mockRepo = new Mock<ActivityRepository>();
            _controller = new ActivitiesController(_mockRepo.Object);
        }

        [Test]
        public async Task Get_ShouldReturnOkResult()
        {
            var activities = new[] { new ActivityReadDto(), new ActivityReadDto() };
            _mockRepo.Setup(x => x.GetAllAsync()).ReturnsAsync(activities);

            var result = await _controller.Get();

            Assert.IsInstanceOf<OkObjectResult>(result);
        }
    }
}
