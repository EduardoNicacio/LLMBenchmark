using MyApp.ViewModels;
using NUnit.Framework;
using static FluentAssertions.FluentAssertions;

namespace MyApp.Tests.ViewModels;

[TestFixture]
public class CreateActivityViewModelTests
{
    [Test]
    public void AllPropertiesShouldBeRequired()
    {
        // Arrange
        var vm = new CreateActivityViewModel();

        // Act & Assert
        vm.Validate().Should().BeEmpty();
    }

    [Test]
    public void Validation_Fails_WhenNameIsBlank()
    {
        // Arrange
        var vm = new CreateActivityViewModel
        {
            Name = string.Empty,
            Description = "Desc",
            ActiveFlag = 1,
            SystemDeleteFlag = 'Y',
            CreatedByUser = "Dave"
        };

        // Act
        var validationResult = vm.Validate();

        // Assert
        validationResult.Should().ContainErrorFor(v => v.Name);
    }

    [Test]
    public void Validation_Passes_WhenAllFieldsAreValid()
    {
        // Arrange
        var vm = new CreateActivityViewModel
        {
            ProjectId = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name = "Project Kickoff",
            Description = "Kickoff meeting for the project.",
            StartDate = DateTime.Today.AddDays(-5),
            TargetDate = DateTime.Today.AddDays(10),
            EndDate = DateTime.Today,
            ProgressStatus = (byte)3,
            ActivityPoints = short.Parse("7"),
            Priority = (byte)2,
            Risk = (byte)1,
            Tags = "Kickoff, Planning",
            ActiveFlag = 1,
            SystemDeleteFlag = 'Y',
            CreatedByUser = "Eve",
            CreatedByProgram = "MyApp"
        };

        // Act
        var validationResult = vm.Validate();

        // Assert
        validationResult.Should().BeEmpty();
    }
}
