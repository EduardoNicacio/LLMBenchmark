// Unit Tests: ActivityModelTests.cs
using NUnit.Framework;
using System;

namespace ActivityManagement.Tests
{
    [TestFixture]
    public class ActivityModelTests
    {
        [Test]
        public void ActivityModel_CanBeConstructed_WithValidData()
        {
            var model = new ActivityModel
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "A test description",
                StartDate = new DateTime(2025, 1, 1),
                TargetDate = new DateTime(2025, 1, 31),
                EndDate = new DateTime(2025, 2, 1),
                ProgressStatus = 50,
                ActivityPoints = 10,
                Priority = 2,
                Risk = 3,
                Tags = "Test,Priority",
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "User1",
                CreatedByProgram = "App1"
            };

            Assert.That(model.ActivityId, Is.Not.Zero);
            Assert.That(model.Name, Is.EqualTo("Test Activity"));
            Assert.That(model.Description, Is.EqualTo("A test description"));
            Assert.That(model.StartDate, Is.Not.Null);
            Assert.That(model.ProgressStatus, Is.EqualTo(50));
            Assert.That(model.ActiveFlag, Is.EqualTo(1));
        }

        [Test]
        public void ActivityModel_WithEmptyName_ThrowsException()
        {
            Assert.Throws<ArgumentException>(() => new ActivityModel
            {
                Name = string.Empty
            });
        }
    }
}
