// ActivityModelTests.cs - NUnit tests for the model
using System;
using System.ComponentModel.DataAnnotations;
using NUnit.Framework;

namespace YourApp.Tests.Models

{
    public class ActivityTests
    {
        [Test]
        public void Activity_Should_Be_Valid_With_Mandatory_Fields()
        {
            var activity = new Activity
            {
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "Description",
                ActiveFlag = true,
                SystemDeleteFlag = "N",
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "Test User",
                CreatedByProgram = "Test Program"
            };
            
            var validationContext = new ValidationContext(activity, null, null);
            var results = new List<ValidationResult>();
            bool isValid = Validator.TryValidateObject(activity, validationContext, results, true);

            Assert.IsTrue(isValid);
        }
        
        [Test]
        public void Activity_Name_Should_Be_Required()
        {
            var activity = new Activity { Name = null };
            
            var validationContext = new ValidationContext(activity, null, null);
            var results = new List<ValidationResult>();
            bool isValid = Validator.TryValidateObject(activity, validationContext, results, true);

            Assert.IsFalse(isValid);
        }
    }
}
