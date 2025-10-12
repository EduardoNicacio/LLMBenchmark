using MyApp.Dtos.Activity;
using NUnit.Framework;
using static FluentAssertions.FluentAssertions;

namespace MyApp.Tests.Dtos;

[TestFixture]
public class CreateActivityDtoTests
{
    [Test]
    public void Validate_Should_Pass_WhenAllPropertiesAreValid()
    {
        // Arrange
        var dto = new CreateActivityDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "New Activity",
            Description = "A description for the activity.",
            StartDate = DateTime.Today.AddDays(-7),
            TargetDate = DateTime.Today.AddDays(14),
            EndDate = DateTime.Today,
            ProgressStatus = (byte)2,
            ActivityPoints = short.Parse("3"),
            Priority = (byte)1,
            Risk = (byte)0,
            Tags = "Alpha, Beta",
            ActiveFlag = 1,
            SystemDeleteFlag = 'Y',
            CreatedByUser = "Alice Smith",
            CreatedByProgram = "MyApp"
        };

        // Act
        var validationResult = new ValidationAttributeList().Validate(dto);

        // Assert
        validationResult.Should().BeEmpty();
    }

    [Test]
    public void Validate_Should_Fail_WhenNameIsTooLong()
    {
        // Arrange
        var dto = new CreateActivityDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = new string('A', 130), // exceeds max length of 128
            Description = "Desc",
            ActiveFlag = 1,
            SystemDeleteFlag = 'Y',
            CreatedByUser = "Bob",
            CreatedByProgram = "MyApp"
        };

        // Act
        var validationResult = new ValidationAttributeList().Validate(dto);

        // Assert
        validationResult.Should().ContainErrorFor(d => d.Name);
    }

    [Test]
    public void Validate_Should_Fail_WhenActiveFlagIsNotZeroOrOne()
    {
        // Arrange
        var dto = new CreateActivityDto
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Valid",
            Description = "Desc",
            ActiveFlag = 2, // invalid value (should be 0 or 1)
            SystemDeleteFlag = 'Y',
            CreatedByUser = "Carol",
            CreatedByProgram = "MyApp"
        };

        // Act
        var validationResult = new ValidationAttributeList().Validate(dto);

        // Assert
        validationResult.Should().ContainErrorFor(d => d.ActiveFlag);
    }
}
