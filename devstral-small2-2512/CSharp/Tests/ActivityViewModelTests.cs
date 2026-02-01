using System;
using NUnit.Framework;
using ProjectManagement.ViewModels;

namespace ProjectManagement.Tests.Unit.ViewModels
{
    [TestFixture]
    public class ActivityViewModelTests
    {
        [Test]
        public void CreateViewModel_WhenValid_ShouldHaveRequiredFields()
        {
            // Arrange
            var vm = new ActivityCreateViewModel
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "New Activity",
                Description = "Activity description"
            };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(vm.ProjectId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(vm.ProjectMemberId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(vm.Name, Is.Not.Empty);
                Assert.That(vm.Description, Is.Not.Empty);
                Assert.That(vm.ActiveFlag, Is.True);
            });
        }

        [Test]
        public void UpdateViewModel_WhenValid_ShouldHaveRequiredFields()
        {
            // Arrange
            var vm = new ActivityUpdateViewModel
            {
                ActivityId = Guid.NewGuid(),
                Name = "Updated Activity",
                Description = "Updated description"
            };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(vm.ActivityId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(vm.Name, Is.Not.Empty);
                Assert.That(vm.Description, Is.Not.Empty);
            });
        }

        [Test]
        public void ListViewModel_WhenCreated_ShouldInitializeCollections()
        {
            // Arrange & Act
            var vm = new ActivityListViewModel();

            // Assert
            Assert.That(vm.Activities, Is.Not.Null);
            Assert.That(vm.TotalCount, Is.EqualTo(0));
            Assert.That(vm.PageNumber, Is.EqualTo(0));
            Assert.That(vm.PageSize, Is.EqualTo(0));
        }

        [Test]
        public void ActivitySummaryViewModel_WhenCreated_ShouldHaveProperties()
        {
            // Arrange
            var vm = new ActivitySummaryViewModel
            {
                ActivityId = Guid.NewGuid(),
                Name = "Summary Activity",
                Description = "Summary description",
                ActiveFlag = true
            };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(vm.ActivityId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(vm.Name, Is.Not.Empty);
                Assert.That(vm.Description, Is.Not.Empty);
                Assert.That(vm.ActiveFlag, Is.True);
            });
        }
    }
}
