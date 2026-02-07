// Unit Tests: ActivityViewModelTests.cs
using NUnit.Framework;
using System.ComponentModel.DataAnnotations;

namespace YourProject.Tests
{
    [TestFixture]
    public class ActivityViewModelTests
    {
        [Test]
        public void CreateActivityViewModel_Constructor_InitializesPropertiesCorrectly()
        {
            var model = new CreateActivityViewModel();

            Assert.That(model.ProjectId, Is.EqualTo(Guid.Empty));
            Assert.That(model.ProjectMemberId, Is.EqualTo(Guid.Empty));
            Assert.That(model.Name, Is.Empty);
            Assert.That(model.Description, Is.Empty);
            Assert.That(model.StartDate, Is.Null);
            Assert.That(model.TargetDate, Is.Null);
            Assert.That(model.EndDate, Is.Null);
            Assert.That(model.ProgressStatus, Is.Null);
            Assert.That(model.ActivityPoints, Is.Null);
            Assert.That(model.Priority, Is.Null);
            Assert.That(model.Risk, Is.Null);
            Assert.That(model.Tags, Is.Null);
        }

        [Test]
        public void UpdateActivityViewModel_Constructor_InitializesPropertiesCorrectly()
        {
            var model = new UpdateActivityViewModel();

            Assert.That(model.ProjectId, Is.EqualTo(Guid.Empty));
            Assert.That(model.ProjectMemberId, Is.EqualTo(Guid.Empty));
            Assert.That(model.Name, Is.Null);
            Assert.That(model.Description, Is.Null);
            Assert.That(model.StartDate, Is.Null);
            Assert.That(model.TargetDate, Is.Null);
            Assert.That(model.EndDate, Is.Null);
            Assert.That(model.ProgressStatus, Is.Null);
            Assert.That(model.ActivityPoints, Is.Null);
            Assert.That(model.Priority, Is.Null);
            Assert.That(model.Risk, Is.Null);
            Assert.That(model.Tags, Is.Null);
        }

        [Test]
        public void ListActivityViewModel_Constructor_InitializesPropertiesCorrectly()
        {
            var model = new ListActivityViewModel();

            Assert.That(model.ActivityId, Is.EqualTo(Guid.Empty));
            Assert.That(model.Name, Is.Empty);
            Assert.That(model.Description, Is.Empty);
            Assert.That(model.StartDate, Is.Null);
            Assert.That(model.TargetDate, Is.Null);
            Assert.That(model.EndDate, Is.Null);
            Assert.That(model.ProjectName, Is.Empty);
            Assert.That(model.ProjectMemberName, Is.Empty);
            Assert.That(model.ProgressStatus, Is.Null);
            Assert.That(model.ActivityPoints, Is.Null);
            Assert.That(model.Priority, Is.Null);
            Assert.That(model.Risk, Is.Null);
            Assert.That(model.Tags, Is.Empty);
            Assert.That(model.ActiveFlag, Is.EqualTo(0));
            Assert.That(model.CreatedDateTime, Is.EqualTo(DateTime.MinValue));
            Assert.That(model.CreatedByUser, Is.Empty);
            Assert.That(model.UpdatedDateTime, Is.Null);
            Assert.That(model.UpdatedByUser, Is.Null);
        }

        [Test]
        public void CreateActivityViewModel_Setters_AssignValuesCorrectly()
        {
            var model = new CreateActivityViewModel();

            model.ProjectId = Guid.NewGuid();
            model.ProjectMemberId = Guid.NewGuid();
            model.Name = "Test Activity";
            model.Description = "Test Description";
            model.StartDate = DateTime.Now;
            model.TargetDate = DateTime.Now.AddDays(1);
            model.EndDate = DateTime.Now.AddDays(2);
            model.ProgressStatus = 50;
            model.ActivityPoints = 100;
            model.Priority = 3;
            model.Risk = 2;
            model.Tags = "tag1,tag2";

            Assert.That(model.ProjectId, Is.Not.EqualTo(Guid.Empty));
            Assert.That(model.Name, Is.EqualTo("Test Activity"));
            Assert.That(model.Description, Is.EqualTo("Test Description"));
            Assert.That(model.StartDate, Is.EqualTo(DateTime.Now));
            Assert.That(model.TargetDate, Is.EqualTo(DateTime.Now.AddDays(1)));
            Assert.That(model.EndDate, Is.EqualTo(DateTime.Now.AddDays(2)));
            Assert.That(model.ProgressStatus, Is.EqualTo(50));
            Assert.That(model.ActivityPoints, Is.EqualTo(100));
            Assert.That(model.Priority, Is.EqualTo(3));
            Assert.That(model.Risk, Is.EqualTo(2));
            Assert.That(model.Tags, Is.EqualTo("tag1,tag2"));
        }

        [Test]
        public void UpdateActivityViewModel_Setters_AssignValuesCorrectly()
        {
            var model = new UpdateActivityViewModel();

            model.ProjectId = Guid.NewGuid();
            model.ProjectMemberId = Guid.NewGuid();
            model.Name = "Test Activity";
            model.Description = "Test Description";
            model.StartDate = DateTime.Now;
            model.TargetDate = DateTime.Now.AddDays(1);
            model.EndDate = DateTime.Now.AddDays(2);
            model.ProgressStatus = 50;
            model.ActivityPoints = 100;
            model.Priority = 3;
            model.Risk = 2;
            model.Tags = "tag1,tag2";

            Assert.That(model.ProjectId, Is.Not.EqualTo(Guid.Empty));
            Assert.That(model.Name, Is.EqualTo("Test Activity"));
            Assert.That(model.Description, Is.EqualTo("Test Description"));
            Assert.That(model.StartDate, Is.EqualTo(DateTime.Now));
            Assert.That(model.TargetDate, Is.EqualTo(DateTime.Now.AddDays(1)));
            Assert.That(model.EndDate, Is.EqualTo(DateTime.Now.AddDays(2)));
            Assert.That(model.ProgressStatus, Is.EqualTo(50));
            Assert.That(model.ActivityPoints, Is.EqualTo(100));
            Assert.That(model.Priority, Is.EqualTo(3));
            Assert.That(model.Risk, Is.EqualTo(2));
            Assert.That(model.Tags, Is.EqualTo("tag1,tag2"));
        }
    }
}
