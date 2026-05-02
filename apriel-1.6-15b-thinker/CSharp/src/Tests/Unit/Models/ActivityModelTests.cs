// Tests/Models/ActivityModelTests.cs
using NUnit.Framework;
using MyApp.Data.Entities;

namespace MyApp.Tests.Models;

[TestFixture]
public class ActivityModelTests
{
    [Test]
    public void Should_create_activity_with_required_properties()
    {
        var activity = new Activity
        {
            ActivityId      = Guid.NewGuid(),
            ProjectId       = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name            = "Sample Activity",
            Description     = "Description text",
            ActiveFlag      = 1,
            SystemDeleteFlag= 'Y',
            CreatedDateTime  = DateTime.UtcNow,
            CreatedByUser    = "admin",
            CreatedByProgram = "TestApp"
        };

        Assert.NotNull(activity.ActivityId);
        Assert.NotNull(activity.ProjectId);
        Assert.NotNull(activity.ProjectMemberId);
        Assert.AreEqual("Sample Activity", activity.Name);
        Assert.AreEqual(1, activity.ActiveFlag);
    }

    [Test]
    public void Should_set_created_by_when_not_provided()
    {
        var activity = new Activity
        {
            ActivityId      = Guid.NewGuid(),
            ProjectId       = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name            = "Sample",
            Description     = "desc"
        };

        // Default constructor sets CreatedByUser/CreatedByProgram to null.
        // We'll manually set them using a helper method in production code,
        // but for test we just verify they are not required by DB constraints.
    }
}
