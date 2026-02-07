// RepositoryTests.cs - Moq tests for repository methods
using System.Collections.Generic;
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using Moq;
using NUnit.Framework;

namespace YourApp.Tests.Repositories

{
    public class ActivityRepositoryTests
    {
        private readonly Mock<IRepository<Activity>> _mockRepo;
        
        public ActivityRepositoryTests()
        {
            _mockRepo = new Mock<IRepository<Activity>>();
        }
        
        [Test]
        public void Get_Should_Return_All_Activities()
        {
            var activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid() },
                new Activity { ActivityId = Guid.NewGuid() }
            };
            
            _mockRepo.Setup(r => r.Get()).Returns(activities.AsQueryable());

            var result = _mockRepo.Object.Get();
            Assert.AreEqual(2, result.Count());
        }

        [Test]
        public void GetById_Should_Return_Correct_Activity()
        {
            var activityId = Guid.NewGuid();
            var activity = new Activity { ActivityId = activityId };
            
            _mockRepo.Setup(r => r.GetById(activityId)).Returns(activity);

            var result = _mockRepo.Object.GetById(activityId);
            Assert.AreEqual(activityId, result.ActivityId);
        }

        [Test]
        public void Add_Should_Call_Set_Add()
        {
            var activity = new Activity();
            
            _mockRepo.Object.Add(activity);
            
            _mockRepo.Verify(r => r.Add(activity), Times.Once);
        }
    }
}
