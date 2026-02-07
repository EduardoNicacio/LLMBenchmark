// CreateActivityDtoTests.cs - NUnit tests for DTO
using System.ComponentModel.DataAnnotations;
using NUnit.Framework;

namespace YourApp.Tests.DTOs

{
    public class CreateActivityDtoTests
    {
        [Test]
        public void CreateActivityDto_Should_Be_Valid_With_Mandatory_Fields()
        {
            var dto = new CreateActivityDto
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Description",
                ActiveFlag = true,
                SystemDeleteFlag = "N",
                CreatedByUser = "Test User",
                CreatedByProgram = "Test Program"
            };
            
            var validationContext = new ValidationContext(dto, null, null);
            var results = new List<ValidationResult>();
            bool isValid = Validator.TryValidateObject(dto, validationContext, results, true);

            Assert.IsTrue(isValid);
        }
        
        [Test]
        public void CreateActivityDto_Name_Should_Be_Required()
        {
            var dto = new CreateActivityDto { Name = null };
            
            var validationContext = new ValidationContext(dto, null, null);
            var results = new List<ValidationResult>();
            bool isValid = Validator.TryValidateObject(dto, validationContext, results, true);

            Assert.IsFalse(isValid);
        }
    }
}
