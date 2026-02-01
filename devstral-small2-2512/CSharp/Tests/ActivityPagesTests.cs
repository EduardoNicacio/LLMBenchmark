using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Moq;
using NUnit.Framework;
using ProjectManagement.Data.Repositories;
using ProjectManagement.Models;
using ProjectManagement.Pages.Activities;
using ProjectManagement.ViewModels;

namespace ProjectManagement.Tests.Integration.Pages
{
    [TestFixture]
    public class ActivityPagesTests
    {
        private Mock<IActivityRepository> _mockRepository;
        private List<Activity> _activities;

        [SetUp]
        public void SetUp()
        {
            _mockRepository = new Mock<IActivityRepository>();
            _activities = new List<Activity>
            {
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 1", ActiveFlag = true, SystemDeleteFlag = "N" },
                new Activity { ActivityId = Guid.NewGuid(), Name = "Activity 2", ActiveFlag = false, SystemDeleteFlag = "N" }
            };
        }

        [Test]
        public async Task IndexModel_OnGetAsync_ShouldReturnPageWithActivities()
        {
            // Arrange
            _mockRepository.Setup(m => m.GetAllAsync()).ReturnsAsync(_activities);
            var model = new IndexModel(_mockRepository.Object);

            // Act
            var result = await model.OnGetAsync();

            // Assert
            Assert.That(result, Is.InstanceOf<PageResult>());
        }

        [Test]
        public async Task CreateModel_OnPostAsync_WhenValid_ShouldRedirectToIndex()
        {
            // Arrange
            _mockRepository.Setup(m => m.AddAsync(It.IsAny<Activity>())).Returns(Task.CompletedTask);
            var model = new CreateModel(_mockRepository.Object)
            {
                Activity = new ActivityCreateViewModel
                {
                    ProjectId = Guid.NewGuid(),
                    ProjectMemberId = Guid.NewGuid(),
                    Name = "New Activity",
                    Description = "Description"
                }
            };

            // Act
            var result = await model.OnPostAsync();

            // Assert
            Assert.That(result, Is.InstanceOf<RedirectToPageResult>());
            var redirectResult = result as RedirectToPageResult;
            Assert.That(redirectResult.PageName, Is.EqualTo("Index"));
        }

        [Test]
        public async Task EditModel_OnGetAsync_WhenCalledWithValidId_ShouldReturnPage()
        {
            // Arrange
            var activityId = _activities[0].ActivityId;
            _mockRepository.Setup(m => m.GetByIdAsync(activityId)).ReturnsAsync(_activities[0]);
            var model = new EditModel(_mockRepository.Object);

            // Act
            var result = await model.OnGetAsync(activityId);

            // Assert
            Assert.That(result, Is.InstanceOf<PageResult>());
        }

        [Test]
        public async Task DetailsModel_OnGetAsync_WhenCalledWithValidId_ShouldReturnPage()
        {
            // Arrange
            var activityId = _activities[0].ActivityId;
            _mockRepository.Setup(m => m.GetByIdAsync(activityId)).ReturnsAsync(_activities[0]);
            var model = new DetailsModel(_mockRepository.Object);

            // Act
            var result = await model.OnGetAsync(activityId);

            // Assert
            Assert.That(result, Is.InstanceOf<PageResult>());
        }

        [Test]
        public async Task DeleteModel_OnPostAsync_WhenCalledWithValidId_ShouldRedirectToIndex()
        {
            // Arrange
            var activityId = _activities[0].ActivityId;
            _mockRepository.Setup(m => m.GetByIdAsync(activityId)).ReturnsAsync(_activities[0]);
            _mockRepository.Setup(m => m.Update(It.IsAny<Activity>())).Callback(() =>
            {
                // Mark as deleted in memory
                _activities[0].SystemDeleteFlag = "Y";
            });

            var model = new DeleteModel(_mockRepository.Object)
            {
                Activity = new Activity { ActivityId = activityId }
            };

            // Act
            var result = await model.OnPostAsync();

            // Assert
            Assert.That(result, Is.InstanceOf<RedirectToPageResult>());
            var redirectResult = result as RedirectToPageResult;
            Assert.That(redirectResult.PageName, Is.EqualTo("Index"));
        }
    }
}
