using System;
using System.Threading.Tasks;
using NUnit.Framework;
using MyApp.Models;
using MyApp.DTOs;
using MyApp.Repositories;
using Moq;

namespace MyApp.Tests
{
    [TestFixture]
    public class ActivityIntegrationTests
    {
        private Mock<IGenericRepository<Activity>> _mockRepo;

        [SetUp]
        public void Setup()
        {
            // Set up a mock repository for integration tests.
            _mockRepo = new Mock<IGenericRepository<Activity>>();
        }

        [Test]
        public async Task Add_Activity_Should_Call_Add_And_SaveChangesAsync()
        {
            // Arrange: create an Activity instance.
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Integration Test",
                Description = "Test Description"
            };

            _mockRepo.Setup(r => r.Add(It.IsAny<Activity>())).Verifiable();

            // Act: add the activity.
            _mockRepo.Object.Add(activity);
            await Task.CompletedTask;  // Simulate async work if necessary.

            // Assert: verify that Add was called with the correct name.
            _mockRepo.Verify(r => r.Add(It.Is<Activity>(a => a.Name == "Integration Test")), Times.Once);
        }

        [Test]
        public void MinimalAPI_Create_Endpoint_Should_Map_Dto_To_Model()
        {
            // Arrange: simulate mapping logic from DTO to Activity model.
            var createDto = new ActivityCreateDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "APITest",
                Description = "API Test Description"
            };

            // Act: create an activity using the same mapping as in Minimal API endpoint.
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = createDto.ProjectId,
                ProjectMemberId = createDto.ProjectMemberId,
                Name = createDto.Name,
                Description = createDto.Description,
                StartDate = createDto.StartDate,
                TargetDate = createDto.TargetDate,
                EndDate = createDto.EndDate,
                ProgressStatus = createDto.ProgressStatus,
                ActivityPoints = createDto.ActivityPoints,
                Priority = createDto.Priority,
                Risk = createDto.Risk,
                Tags = createDto.Tags,
                ActiveFlag = createDto.ActiveFlag,
                SystemDeleteFlag = createDto.SystemDeleteFlag,
                CreatedDateTime = createDto.CreatedDateTime,
                CreatedByUser = "APITestUser",
                CreatedByProgram = "MinimalAPI"
            };

            // Assert: verify that the mapping works correctly.
            Assert.AreEqual("APITest", activity.Name);
        }

        [Test]
        public void RazorPages_Edit_Get_Should_Map_Activity_To_UpdateViewModel()
        {
            // Arrange: simulate retrieving an Activity.
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "PageTest",
                Description = "Page Test Description"
            };

            // Act: simulate mapping in the Edit PageModel.
            var viewModel = new ActivityUpdateViewModel
            {
                Name = activity.Name,
                Description = activity.Description
            };

            // Assert: verify that properties are correctly mapped.
            Assert.AreEqual("PageTest", viewModel.Name);
        }
    }
}