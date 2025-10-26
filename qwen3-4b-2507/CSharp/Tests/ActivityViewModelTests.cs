// Unit Tests: ActivityViewModelTests.cs
using NUnit.Framework;
using System;

namespace ActivityManagement.Tests
{
    [TestFixture]
    public class ActivityViewModelTests
    {
        [Test]
        public void CreateViewModel_HasCorrectProperties()
        {
            var model = new CreateActivityViewModel
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test",
                Description = "Test desc",
                StartDate = new DateTime(2025, 1, 1),
                TargetDate = new DateTime(2025, 1, 31),
                EndDate = new DateTime(2025, 2, 1),
                ProgressStatus = 50,
                ActivityPoints = 10,
                Priority = 2,
                Risk = 3,
                Tags = "TestTag",
                IsActive = true,
                IsDeleted = false
            };

            Assert.That(model.Name, Is.EqualTo("Test"));
            Assert.That(model.ProjectId, Is.Not.Zero);
            Assert.That(model.StartDate, Is.Not.Null);
            Assert.That(model.IsActive, Is.True);
        }
    }
}
