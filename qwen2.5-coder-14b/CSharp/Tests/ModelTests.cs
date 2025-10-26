using NUnit.Framework;

namespace ActivityManagement.Tests
{
    [TestFixture]
    public class ModelTests
    {
        [Test]
        public void ActivityModel_ShouldHaveValidProperties()
        {
            var activity = new Activity
            {
                Name = "Test Activity",
                Description = "This is a test activity."
            };

            Assert.IsNotNull(activity.Name);
            Assert.IsNotNull(activity.Description);
        }

        [Test]
        public void CreateDto_ShouldMapToActivityModel()
        {
            var dto = new CreateActivityDto
            {
                Name = "Test Activity",
                Description = "This is a test activity."
            };

            var activity = new Activity
            {
                Name = dto.Name,
                Description = dto.Description
            };

            Assert.AreEqual(dto.Name, activity.Name);
            Assert.AreEqual(dto.Description, activity.Description);
        }
    }
}
