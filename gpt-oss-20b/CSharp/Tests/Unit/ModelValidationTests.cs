// File: Tests/Unit/ModelValidationTests.cs
using System.ComponentModel.DataAnnotations;
using MyApp.Models;
using NUnit.Framework;

namespace MyApp.Tests.Unit;

[TestFixture]
public class ModelValidationTests
{
    private static IEnumerable<object[]> GetValidActivity()
    {
        yield return new object[]
        {
            new Activity
            {
                ActivityId = Guid.NewGuid(),
                ProjectId = Guid.NewGuid(),
                ProjectMemberId = Guid.NewGuid(),
                Name = "Test Activity",
                Description = "A description",
                ActiveFlag = 1,
                SystemDeleteFlag = 'N',
                CreatedDateTime = DateTime.UtcNow,
                CreatedByUser = "unit@test.com",
                CreatedByProgram = "UnitTests"
            }
        };
    }

    [Test, TestCaseSource(nameof(GetValidActivity))]
    public void Activity_Validation_ShouldPass(Activity activity)
    {
        var context = new ValidationContext(activity);
        var results = new List<ValidationResult>();
        bool isValid = Validator.TryValidateObject(activity, context, results, true);

        Assert.IsTrue(isValid, $"Expected validation to pass but got errors: {string.Join(", ", results.Select(r => r.ErrorMessage))}");
    }

    [Test]
    public void Activity_Name_ShouldBeRequired()
    {
        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Description = "Desc",
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "unit@test.com",
            CreatedByProgram = "UnitTests"
        };

        var context = new ValidationContext(activity);
        var results = new List<ValidationResult>();
        bool isValid = Validator.TryValidateObject(activity, context, results, true);

        Assert.IsFalse(isValid);
        Assert.That(results.Any(r => r.MemberNames.Contains("Name")), Is.True);
    }
}
