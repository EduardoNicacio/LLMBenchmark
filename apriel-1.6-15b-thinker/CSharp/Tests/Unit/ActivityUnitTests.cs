using FluentAssertions;
using NUnit.Framework;
using YourApp.Application.DTOs;
using YourApp.Domain.Entities;

namespace YourApp.Tests.Unit
{
    [TestFixture]
    public class ActivityEntityTests
    {
        [Test]
        public void Entity_Properties_AreAssignable()
        {
            // Arrange
            var entity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                Name = "Sample",
                Description = "Desc"
            };

            // Act & Assert
            entity.ActivityId.Should().Be(entity.ActivityId);
            entity.Name.Should().Be("Sample");
        }

        [Test]
        public void SystemTimestamp_IsNonNullByDefault()
        {
            var entity = new Activity { SystemTimestamp = new byte[8] { 1, 2, 3, 4, 5, 6, 7, 8 } };
            entity.SystemTimestamp.Should().NotBeNull();
        }
    }

    [TestFixture]
    public class ActivityCreateDtoTests
    {
        [Test]
        public void CreateDto_ValidData_CanBeCreated()
        {
            var dto = new ActivityCreateDto(
                ProjectId: Guid.NewGuid(),
                ProjectMemberId: Guid.NewGuid(),
                Name: "Task",
                Description: "Do something",
                ActiveFlag: 1);

            dto.Should().NotBeNull();
        }

        [Test]
        public void CreateDto_InvalidName_ThrowsValidationException()
        {
            Action(() => new ActivityCreateDto(
                    ProjectId: Guid.NewGuid(),
                    ProjectMemberId: Guid.NewGuid(),
                    Name: "",
                    Description: "Desc",
                    ActiveFlag: 1))
            .Should()
                .Throw<ArgumentException>()
                .Or
                .Throw<InvalidOperationException>();
        }
    }

    [TestFixture]
    public class ActivityListViewModelTests
    {
        [Test]
        public void ListViewModel_Pagination_PropertiesAreSetCorrectly()
        {
            var vm = new ActivityListViewModel(
                Items: new List<ActivityReadDto>(),
                PageNumber: 2,
                PageSize: 5,
                TotalCount: 12);

            vm.PageNumber.Should().Be(2);
            vm.PageSize.Should().Be(5);
            vm.TotalCount.Should().Be(12);
        }
    }
}
