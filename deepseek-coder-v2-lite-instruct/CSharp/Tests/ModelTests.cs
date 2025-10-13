using NUnit.Framework;
using YourNamespace.Models;
using System;

namespace YourNamespace.Tests
{
    [TestFixture]
    public class ModelTests
    {
        [Test]
        public void Activity_PropertiesAreSetCorrectly()
        {
            var activity = new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                // Set other properties...
            };

            Assert.NotNull(activity);
            Assert.IsInstanceOf<Guid>(activity.ActivityId);
            // Add more assertions for other properties...
        }
    }
}
