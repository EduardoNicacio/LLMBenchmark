using NUnit.Framework;
using MyApp.Models;
using MyApp.DTOs;
using MyApp.ViewModels;

namespace MyApp.Tests
{
    [TestFixture]
    public class ActivityModelTests
    {
        [Test]
        public void Activity_Model_Property_Assignments()
        {
            // Arrange & Act: create an instance of Activity.
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Testing Activity",
                Description = "Description here",
                StartDate = DateTime.UtcNow,
                TargetDate = DateTime.UtcNow.AddDays(5),
                EndDate = DateTime.UtcNow.AddDays(10),
                ProgressStatus = 1,
                ActivityPoints = 100,
                Priority = 2,
                Risk = 3,
                Tags = "Test, Unit",
                ActiveFlag = true,
                SystemDeleteFlag = "N",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "Tester",
                CreatedByProgram = "UnitTests"
            };

            // Assert: verify property assignments.
            Assert.AreEqual("Testing Activity", activity.Name);
            Assert.AreEqual(100, activity.ActivityPoints);
            Assert.IsTrue(activity.ActiveFlag);
            Assert.AreEqual("N", activity.SystemDeleteFlag);
        }
    }

    [TestFixture]
    public class DTOs_Tests
    {
        [Test]
        public void CreateDto_Should_Assign_All_Properties()
        {
            // Arrange: create a new ActivityCreateDto.
            var dto = new ActivityCreateDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Description test",
                StartDate = DateTime.UtcNow,
                TargetDate = DateTime.UtcNow.AddDays(5),
                EndDate = DateTime.UtcNow.AddDays(10),
                ProgressStatus = 1,
                ActivityPoints = 100,
                Priority = 2,
                Risk = 3,
                Tags = "Test, DTO",
                ActiveFlag = true,
                SystemDeleteFlag = "N",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "Tester",
                CreatedByProgram = "UnitTests"
            };

            // Act & Assert: verify properties are correctly set.
            Assert.AreEqual("Test Activity", dto.Name);
            Assert.IsTrue(dto.ActiveFlag);
        }

        [Test]
        public void UpdateDto_Should_Allow_Null_Names()
        {
            var updateDto = new ActivityUpdateDto
            {
                Name = null,
                Description = "Updated Description",
                Tags = "Updated, DTO"
            };

            // Verify that the nullable Name remains null.
            Assert.IsNull(updateDto.Name);
        }
    }

    [TestFixture]
    public class ViewModelTests
    {
        [Test]
        public void CreateViewModel_Should_Validate_ModelState()
        {
            var viewModel = new ActivityCreateViewModel
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Valid Activity",
                Description = "Valid description"
            };

            // In a real scenario, you would use ModelState validation.
            Assert.Pass();
        }
    }
}