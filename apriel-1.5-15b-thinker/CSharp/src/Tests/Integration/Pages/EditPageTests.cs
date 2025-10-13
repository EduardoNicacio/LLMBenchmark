// Tests/Integration/EditPageTests.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using Moq;
using MyApp.Data.Entities;
using MyApp.Data.Repositories;
using System.Threading.Tasks;

namespace MyApp.Tests.Integration;

[TestFixture]
public class EditPageTests
{
    private Mock<IActivityRepository> _repoMock;
    private ActivityEditPageModel _page; // Assuming the edit page model is named Edit.cshtml.cs

    [SetUp]
    public void Setup()
    {
        _repoMock = new Mock<IActivityRepository>();
        var existing = new Activity
        {
            ActivityId      = Guid.NewGuid(),
            ProjectId       = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name            = "Existing",
            Description     = "desc",
            ActiveFlag      = 1,
            SystemDeleteFlag='N',
            CreatedDateTime  = DateTime.UtcNow,
            CreatedByUser    = "System"
        };
        _repoMock.Setup(r => r.GetByIdAsync(existing.ActivityId)).Returns(existing);

        // The edit page model constructor receives the repository.
        _page = new ActivityEditPageModel(_repoMock.Object);
    }

    [Test]
    public async Task OnGet_PopulatesViewModel()
    {
        var id = Guid.NewGuid();
        // Override GetByIdAsync to return a known entity for this test.
        var testEntity = new Activity { ActivityId = id };
        _repoMock.Setup(r => r.GetByIdAsync(id)).Returns(testEntity);

        var args = new PageParameterModel(dict => dict["ActivityId"] = id);
        var result = await _page.OnGetAsync(args);
        Assert.IsType<PageHandledEventArgs>((EventArgs)result);
        // Verify view model fields are set.
        var vm = (UpdateActivityViewModel)_page.Model;
        Assert.AreEqual(id, vm.ActivityId);
        Assert.NotNull(vm.Name);
    }

    [Test]
    public async Task OnPost_UpdatesEntity()
    {
        var id = Guid.NewGuid();
        // Arrange: repository returns entity with known values.
        var original = new Activity
        {
            ActivityId      = id,
            ProjectId       = Guid.NewGuid(),
            Name            = "Original",
            Description     = "orig"
        };
        _repoMock.Setup(r => r.GetByIdAsync(id)).Returns(original);

        // Post data with changed values.
        var vm = new UpdateActivityViewModel
        {
            ActivityId   = id,
            ProjectId    = Guid.NewGuid().ToString(),
            Name         = "New Title",
            Description  = "new desc"
        };

        var result = await _page.OnPostAsync(vm);
        Assert.IsType<RedirectToPageResult>((RedirectToPageResult)result);
        // Verify repository Update called with updated entity.
        _repoMock.Verify(r => r.UpdateAsync(It.Is<Activity>(a =>
            a.ProjectId == Guid.Parse(vm.ProjectId) &&
            a.Name == vm.Name && a.Description == vm.Description)), Times.Once);
    }
}
