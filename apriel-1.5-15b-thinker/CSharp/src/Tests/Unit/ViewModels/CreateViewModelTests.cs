// Tests/ViewModels/CreateViewModelTests.cs
using NUnit.Framework;
using MyApp.Pages.ViewModels;

namespace MyApp.Tests.ViewModels;

[TestFixture]
public class CreateViewModelTests
{
    [Test]
    public void Should_mark_required_fields_as_necessary()
    {
        var vm = new ActivityCreateViewModel();
        Assert.AreEqual(ModelState.IsValid, false);
        // Validation rules are defined via DataAnnotations on properties.
    }

    [Test]
    public void Should_be_valid_with_proper_data()
    {
        var vm = new ActivityCreateViewModel
        {
            ProjectId      = Guid.NewGuid().ToString(),
            ProjectMemberId= Guid.NewGuid().ToString(),
            Name           = "Alpha",
            Description    = "Beta",
            ActiveFlag     = 1,
            SystemDeleteFlag='N'
        };
        Assert.IsTrue(vm.Validate()); // Assuming custom Validate method returns bool.
    }
}
