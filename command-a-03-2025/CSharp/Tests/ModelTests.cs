using ActivityTracker.DTOs;
using ActivityTracker.Models;
using ActivityTracker.ViewModels;
using NUnit.Framework;

namespace ActivityTracker.Tests
{
    [TestFixture]
    public class ModelTests
    {
        [Test]
        public void ActivityModel_ShouldHaveRequiredFields()
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Test Description",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "User",
                CreatedByProgram = "Program"
            };

            Assert.IsNotNull(activity);
            Assert.IsNotEmpty(activity.Name);
        }
    }

    [TestFixture]
    public class DtoTests
    {
        [Test]
        public void CreateActivityDto_ShouldHaveRequiredFields()
        {
            var dto = new CreateActivityDto
            {
                Name = "Test Activity",
                Description = "Test Description",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "User",
                CreatedByProgram = "Program"
            };

            Assert.IsNotNull(dto);
            Assert.IsNotEmpty(dto.Name);
        }
    }

    [TestFixture]
    public class ViewModelTests
    {
        [Test]
        public void CreateActivityViewModel_ShouldHaveRequiredFields()
        {
            var viewModel = new CreateActivityViewModel
            {
                Name = "Test Activity",
                Description = "Test Description"
            };

            Assert.IsNotNull(viewModel);
            Assert.IsNotEmpty(viewModel.Name);
        }
    }
}
