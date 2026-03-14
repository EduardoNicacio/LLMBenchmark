using ActivityApp.Dtos;
using ActivityApp.Models;
using ActivityApp.ViewModels;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using FluentAssertions;

namespace ActivityApp.Tests
{
    [TestClass]
    public class ActivityTests
    {
        [TestMethod]
        public void Activity_Model_Should_Have_All_Properties()
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Test Description",
                StartDate = DateTime.UtcNow,
                TargetDate = DateTime.UtcNow.AddDays(7),
                EndDate = DateTime.UtcNow.AddDays(14),
                ProgressStatus = 50,
                ActivityPoints = 10,
                Priority = 1,
                Risk = 1,
                Tags = "Test,Tag",
                ActiveFlag = true,
                SystemDeleteFlag = false,
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "Admin",
                CreatedByProgram = "System",
                UpdatedDateTime = DateTime.UtcNow,
                UpdatedByUser = "Admin",
                UpdatedByProgram = "System",
                SystemTimestamp = new byte[8]
            };

            activity.Should().NotBeNull();
            activity.Name.Should().Be("Test Activity");
            activity.ActiveFlag.Should().BeTrue();
        }

        [TestMethod]
        public void ActivityCreateDto_Should_Have_Required_Properties()
        {
            var dto = new ActivityCreateDto
            {
                Name = "New Activity",
                Description = "New Description",
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid()
            };

            dto.Name.Should().NotBeNullOrEmpty();
            dto.ProjectId.Should().NotBeEmpty();
        }

        [TestMethod]
        public void ActivityEditViewModel_Should_Have_ActivityId()
        {
            var vm = new ActivityEditViewModel
            {
                ActivityId = Guid.NewGuid(),
                Name = "Updated Name",
                Description = "Updated Description",
                ActiveFlag = true
            };

            vm.ActivityId.Should().NotBeEmpty();
            vm.Name.Should().Be("Updated Name");
        }
    }
}
