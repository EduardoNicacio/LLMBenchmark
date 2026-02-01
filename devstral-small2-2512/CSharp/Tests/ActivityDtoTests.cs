using System;
using NUnit.Framework;
using ProjectManagement.Dtos;

namespace ProjectManagement.Tests.Unit.Dtos
{
    [TestFixture]
    public class ActivityDtoTests
    {
        [Test]
        public void CreateDto_WhenValid_ShouldHaveRequiredFields()
        {
            // Arrange
            var dto = new ActivityCreateDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Test description"
            };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(dto.ProjectId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(dto.ProjectMemberId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(dto.Name, Is.Not.Empty);
                Assert.That(dto.Description, Is.Not.Empty);
            });
        }

        [Test]
        public void UpdateDto_WhenValid_ShouldHaveRequiredFields()
        {
            // Arrange
            var dto = new ActivityUpdateDto
            {
                ActivityId = Guid.NewGuid(),
                Name = "Updated Activity",
                Description = "Updated description"
            };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(dto.ActivityId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(dto.Name, Is.Not.Empty);
                Assert.That(dto.Description, Is.Not.Empty);
            });
        }

        [Test]
        public void ReadDto_WhenCreated_ShouldHaveAllProperties()
        {
            // Arrange
            var dto = new ActivityReadDto
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Read Activity",
                Description = "Read description",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "Test User"
            };

            // Act & Assert
            Assert.Multiple(() =>
            {
                Assert.That(dto.ActivityId, Is.Not.EqualTo(Guid.Empty));
                Assert.That(dto.Name, Is.Not.Empty);
                Assert.That(dto.Description, Is.Not.Empty);
                Assert.That(dto.CreatedDateTime, Is.Not.EqualTo(default(DateTime)));
                Assert.That(dto.CreatedByUser, Is.Not.Empty);
            });
        }
    }
}
