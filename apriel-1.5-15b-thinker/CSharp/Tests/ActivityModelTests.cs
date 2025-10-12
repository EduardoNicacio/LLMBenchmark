using MyApp.Models;
using NUnit.Framework;
using static FluentAssertions.FluentAssertions;

namespace MyApp.Tests.Models;

[TestFixture]
public class ActivityModelTests
{
    [Test]
    public void Activity_Should_HaveAllProperties()
    {
        // Arrange
        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Sample Activity",
            Description = "This is a sample description.",
            StartDate = DateTime.Today.AddDays(-30),
            TargetDate = DateTime.Today.AddDays(30),
            EndDate = DateTime.Today,
            ProgressStatus = (byte)1,
            ActivityPoints = short.Parse("5"),
            Priority = (byte)2,
            Risk = (byte)1,
            Tags = "Tag1, Tag2",
            ActiveFlag = 1,
            SystemDeleteFlag = 'A',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "John Doe",
            CreatedByProgram = "MyApp",
            // Updated fields are null by default
        };

        // Act & Assert
        activity.Should().NotBeNull();
        activity.ActivityId.Should().Be(activity.ActivityId);
        activity.ProjectId.Should().Be(activity.ProjectId);
        activity.Name.Should().Equal("Sample Activity");
        activity.Description.Should().Contain("sample description");
        activity.StartDate.Should().Be(DateTime.Today.AddDays(-30));
        // ... more property checks
    }

    [Test]
    public void Activity_Should_ThrowArgumentNullException_WhenRequiredPropertyMissing()
    {
        // Act
        Func<Activity, Exception> act = async () => await Task.From(() => new Activity());

        // Assert
        act.Should().Throw<AggregateException>
            .And-innerException.Should().BeOfType<ArgumentNullException>();
    }
}
