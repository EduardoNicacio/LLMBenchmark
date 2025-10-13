using NUnit.Framework;
using MyApplication.Models;
using System;

[TestFixture]
public class ActivityTests
{
    [Test]
    public void Activity_PropertiesAreSet()
    {
        var activity = new Activity
        {
            Name = "Test Activity",
            Description = "A test description"
        };

        Assert.IsNotNull(activity.ActivityId);
        Assert.AreEqual("Test Activity", activity.Name);
    }
}
