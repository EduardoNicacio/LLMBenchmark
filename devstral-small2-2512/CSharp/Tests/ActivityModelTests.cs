using System;
using NUnit.Framework;
using ProjectManagement.Models;

namespace ProjectManagement.Tests.Unit.Models
{
    [TestFixture]
    public class ActivityModelTests
    {
        [Test]
        public void Activity_WhenCreated_ShouldHaveValidId()
        {
            // Arrange & Act
            var activity = new Activity();

            // Assert
            Assert.That(activity.ActivityId, Is.Not.EqualTo(Guid.Empty));
        }

        [Test]
        public void Activity_Name_WhenSet_ShouldNotBeEmpty()
        {
            // Arrange
            var activity = new Activity { Name = "Valid Name" };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(activity.Name, Is.Not.Empty);
                Assert.That(activity.Name.Length, Is.LessThanOrEqualTo(128));
            });
        }

        [Test]
        public void Activity_Description_WhenSet_ShouldNotBeEmpty()
        {
            // Arrange
            var activity = new Activity { Description = "Valid description" };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(activity.Description, Is.Not.Empty);
                Assert.That(activity.Description.Length, Is.LessThanOrEqualTo(4000));
            });
        }

        [Test]
        public void Activity_ProgressStatus_WhenSet_ShouldBeInRange()
        {
            // Arrange
            var activity = new Activity { ProgressStatus = 50 };

            // Act & Assert
            Assert.That(activity.ProgressStatus, Is.InRange(0, 100));
        }

        [Test]
        public void Activity_Priority_WhenSet_ShouldBeInRange()
        {
            // Arrange
            var activity = new Activity { Priority = 3 };

            // Act & Assert
            Assert.That(activity.Priority, Is.InRange(0, 5));
        }

        [Test]
        public void Activity_Risk_WhenSet_ShouldBeInRange()
        {
            // Arrange
            var activity = new Activity { Risk = 7 };

            // Act & Assert
            Assert.That(activity.Risk, Is.InRange(0, 10));
        }

        [Test]
        public void Activity_ActiveFlag_DefaultValue_ShouldBeTrue()
        {
            // Arrange & Act
            var activity = new Activity();

            // Assert
            Assert.That(activity.ActiveFlag, Is.True);
        }

        [Test]
        public void Activity_SystemDeleteFlag_DefaultValue_ShouldBeN()
        {
            // Arrange & Act
            var activity = new Activity();

            // Assert
            Assert.That(activity.SystemDeleteFlag, Is.EqualTo("N"));
        }
    }
}
