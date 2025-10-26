// File: Tests/Unit/ViewModelPropertyTests.cs
using MyApp.ViewModels;
using NUnit.Framework;

namespace MyApp.Tests.Unit;

[TestFixture]
public class ViewModelPropertyTests
{
    [Test]
    public void CreateViewModel_Properties_ShouldHave_DefaultValues()
    {
        var vm = new ActivityCreateViewModel();

        Assert.AreEqual(Guid.Empty, vm.ProjectId);
        Assert.IsNull(vm.StartDate);
        // ... other defaults
    }

    [Test]
    public void UpdateViewModel_ShouldAccept_Timestamp()
    {
        var vm = new ActivityUpdateViewModel { SystemTimestamp = new byte[] { 1, 2 } };
        Assert.IsNotNull(vm.SystemTimestamp);
    }
}
