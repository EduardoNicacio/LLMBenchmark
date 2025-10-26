// Tests/ActivityTests.cs

using NUnit.Framework;
using YourNamespace.Models;

namespace YourNamespace.Tests
{
    public class ActivityTests
    {
        [Test]
        public void TestActivityConstructor()
        {
            // Arrange
            var activity = new Activity();

            // Act and Assert
            Assert.IsNotNull(activity);
            Assert.AreEqual(Guid.Empty, activity.ActivityId);
            Assert.AreEqual(Guid.Empty, activity.ProjectId);
            Assert.AreEqual(Guid.Empty, activity.ProjectMemberId);
            Assert.AreEqual(string.Empty, activity.Name);
            Assert.AreEqual(string.Empty, activity.Description);
            Assert.IsNull(activity.StartDate);
            Assert.IsNull(activity.TargetDate);
            Assert.IsNull(activity.EndDate);
            Assert.IsNull(activity.ProgressStatus);
            Assert.IsNull(activity.ActivityPoints);
            Assert.AreEqual(1, activity.Priority);
            Assert.AreEqual(1, activity.Risk);
            Assert.IsNull(activity.Tags);
        }

        [Test]
        public void TestActivityValidation()
        {
            // Arrange
            var activity = new Activity();
            activity.Name = string.Empty;
            activity.Description = string.Empty;

            // Act and Assert
            Assert.IsTrue(activity.Validate());
            Assert.IsFalse(activity.IsValid());
        }
    }
}
