using NUnit.Framework;
using System;

[TestFixture]
public class ModelTests
{
    [Test]
    public void Activity_ShouldHaveValidProperties()
    {
        // Arrange & Act
        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Test Activity",
            Description = "Test description",
            StartDate = DateTime.Now.Date,
            TargetDate = DateTime.Now.Date.AddDays(7),
            EndDate = null,
            ProgressStatus = 1,
            ActivityPoints = 5,
            Priority = 2,
            Risk = 3,
            Tags = "tag1, tag2",
            ActiveFlag = 1,
            SystemDeleteFlag = 'N',
            CreatedDateTime = DateTime.UtcNow,
            CreatedByUser = "user1",
            CreatedByProgram = "app1",
            UpdatedDateTime = null,
            UpdatedByUser = null,
            UpdatedByProgram = null
        };

        // Assert
        Assert.AreEqual("Test Activity", activity.Name);
        Assert.AreEqual(5, activity.ActivityPoints);
        Assert.AreEqual('N', activity.SystemDeleteFlag);
    }
}

[TestFixture]
public class DtoTests
{
    [Test]
    public void CreateDto_ShouldValidateRequiredFields()
    {
        var createDto = new ActivityCreateDto();
        var validationResults = new List<ValidationResult>();
        var context = new ValidationContext(createDto, serviceProvider: null);

        bool isValid = Validator.TryValidateObject(createDto, context, validationResults, true);

        Assert.IsFalse(isValid);
        Assert.AreEqual(3, validationResults.Count); // Name, ProjectId, ProjectMemberId are required
    }
}

[TestFixture]
public class ViewModelTests
{
    [Test]
    public void ActivityViewModel_ShouldMapPropertiesCorrectly()
    {
        var activity = new Activity
        {
            ActivityId = Guid.NewGuid(),
            Name = "Test Activity",
            Description = "Test description"
        };

        var viewModel = new ActivityViewModel
        {
            ActivityId = activity.ActivityId,
            Name = activity.Name,
            Description = activity.Description
        };

        Assert.AreEqual(activity.ActivityId, viewModel.ActivityId);
        Assert.AreEqual(activity.Name, viewModel.Name);
        Assert.AreEqual(activity.Description, viewModel.Description);
    }
}
