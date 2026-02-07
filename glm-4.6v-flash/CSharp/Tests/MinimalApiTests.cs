// MinimalApiTests.cs - Moq tests for API endpoints
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using NUnit.Framework;

namespace YourApp.Tests.MinimalApi

{
    public class ActivitiesControllerTests
    {
        private readonly Mock<IRepository<Activity>> _mockRepo;
        private readonly ActivitiesController _controller;
        
        public ActivitiesControllerTests()
        {
            _mockRepo = new Mock<IRepository<Activity>>();
            
            var services = new ServiceCollection();
            services.AddSingleton(_mockRepo.Object);
            services.AddControllers(); // Minimal API dependency injection
            
            var serviceProvider = services.BuildServiceProvider();
            
            _controller = serviceProvider.GetRequiredService<ActivitiesController>();
        }
        
        [Test]
        public void GetActivities_Returns_Ok()
        {
            var activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid() },
                new Activity { ActivityId = Guid.NewGuid() }
            };
            
            _mockRepo.Setup(r => r.Get()).Returns(activities.AsQueryable());

            var result = _controller.GetActivities();
            Assert.IsInstanceOf<OkObjectResult>(result);
        }

        [Test]
        public void GetActivity_Returns_Ok()
        {
            var activityId = Guid.NewGuid();
            var activity = new Activity { ActivityId = activityId };
            
            _mockRepo.Setup(r => r.GetById(activityId)).Returns(activity);

            var result = _controller.GetActivity(activityId);
            Assert.IsInstanceOf<OkObjectResult>(result);
        }

        [Test]
        public void PostActivity_Returns_Created()
        {
            var createDto = new CreateActivityDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "New Activity",
                Description = "Description"
            };
            
            _mockRepo.Setup(r => r.Add(It.IsAny<Activity>())).Returns(new Activity { ActivityId = Guid.NewGuid() });
            
            var result = _controller.PostActivity(createDto);
            Assert.IsInstanceOf<CreatedAtActionResult>(result);
        }
    }
}
