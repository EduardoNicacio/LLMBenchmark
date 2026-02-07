// Unit Tests: ActivityModelTests.cs
using NUnit.Framework;
using System;

namespace YourProject.Tests
{
    [TestFixture]
    public class ActivityModelTests
    {
        [Test]
        public void Activity_Constructor_InitializesPropertiesCorrectly()
        {
            var activity = new Activity();

            Assert.That(activity.ActivityId, Is.EqualTo(Guid.Empty));
            Assert.That(activity.ProjectId, Is.EqualTo(Guid.Empty));
            Assert.That(activity.ProjectMemberId, Is.EqualTo(Guid.Empty));
            Assert.That(activity.Name, Is.Empty);
            Assert.That(activity.Description, Is.Empty);
            Assert.That(activity.StartDate, Is.Null);
            Assert.That(activity.TargetDate, Is.Null);
            Assert.That(activity.EndDate, Is.Null);
            Assert.That(activity.ProgressStatus, Is.Null);
            Assert.That(activity.ActivityPoints, Is.Null);
            Assert.That(activity.Priority, Is.Null);
            Assert.That(activity.Risk, Is.Null);
            Assert.That(activity.Tags, Is.Null);
            Assert.That(activity.ActiveFlag, Is.EqualTo(0));
            Assert.That(activity.SystemDeleteFlag, Is.EqualTo('N'));
            Assert.That(activity.CreatedDateTime, Is.EqualTo(DateTime.MinValue));
            Assert.That(activity.CreatedByUser, Is.Empty);
            Assert.That(activity.CreatedByProgram, Is.Empty);
            Assert.That(activity.UpdatedDateTime, Is.Null);
            Assert.That(activity.UpdatedByUser, Is.Null);
            Assert.That(activity.UpdatedByProgram, Is.Null);
            Assert.That(activity.SystemTimestamp, Is.Empty);
        }

        [Test]
        public void Activity_Setters_AssignValuesCorrectly()
        {
            var activity = new Activity();

            activity.ActivityId = Guid.NewGuid();
            activity.ProjectId = Guid.NewGuid();
            activity.ProjectMemberId = Guid.NewGuid();
            activity.Name = "Test Activity";
            activity.Description = "Test Description";
            activity.StartDate = DateTime.Now;
            activity.TargetDate = DateTime.Now.AddDays(1);
            activity.EndDate = DateTime.Now.AddDays(2);
            activity.ProgressStatus = 50;
            activity.ActivityPoints = 100;
            activity.Priority = 3;
            activity.Risk = 2;
            activity.Tags = "tag1,tag2";
            activity.ActiveFlag = 1;
            activity.SystemDeleteFlag = 'Y';
            activity.CreatedDateTime = DateTime.UtcNow;
            activity.CreatedByUser = "TestUser";
            activity.CreatedByProgram = "TestProgram";
            activity.UpdatedDateTime = DateTime.UtcNow;
            activity.UpdatedByUser = "TestUser";
            activity.UpdatedByProgram = "TestProgram";
            activity.SystemTimestamp = new byte[8];

            Assert.That(activity.ActivityId, Is.Not.EqualTo(Guid.Empty));
            Assert.That(activity.Name, Is.EqualTo("Test Activity"));
            Assert.That(activity.Description, Is.EqualTo("Test Description"));
            Assert.That(activity.StartDate, Is.EqualTo(DateTime.Now));
            Assert.That(activity.TargetDate, Is.EqualTo(DateTime.Now.AddDays(1)));
            Assert.That(activity.EndDate, Is.EqualTo(DateTime.Now.AddDays(2)));
            Assert.That(activity.ProgressStatus, Is.EqualTo(50));
            Assert.That(activity.ActivityPoints, Is.EqualTo(100));
            Assert.That(activity.Priority, Is.EqualTo(3));
            Assert.That(activity.Risk, Is.EqualTo(2));
            Assert.That(activity.Tags, Is.EqualTo("tag1,tag2"));
            Assert.That(activity.ActiveFlag, Is.EqualTo(1));
            Assert.That(activity.SystemDeleteFlag, Is.EqualTo('Y'));
            Assert.That(activity.CreatedDateTime, Is.EqualTo(DateTime.UtcNow));
            Assert.That(activity.CreatedByUser, Is.EqualTo("TestUser"));
            Assert.That(activity.CreatedByProgram, Is.EqualTo("TestProgram"));
            Assert.That(activity.UpdatedDateTime, Is.EqualTo(DateTime.UtcNow));
            Assert.That(activity.UpdatedByUser, Is.EqualTo("TestUser"));
            Assert.That(activity.UpdatedByProgram, Is.EqualTo("TestProgram"));
            Assert.That(activity.SystemTimestamp, Is.EqualTo(new byte[8]));
        }
    }
}
