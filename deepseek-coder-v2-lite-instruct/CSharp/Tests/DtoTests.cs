using NUnit.Framework;
using YourNamespace.DTOs;
using System;

namespace YourNamespace.Tests
{
    [TestFixture]
    public class DtoTests
    {
        [Test]
        public void ActivityCreateDto_PropertiesAreSetCorrectly()
        {
            var dto = new ActivityCreateDto
            {
                ProjectId = Guid.NewGuid(),
                // Set other properties...
            };

            Assert.NotNull(dto);
            Assert.IsInstanceOf<Guid>(dto.ProjectId);
            // Add more assertions for other properties...
        }
    }
}
