// Tests/Integration/CreatePageTests.cs
using Microsoft.AspNetCore.Mvc.RazorPages;
using Moq;
using MyApp.Data.Entities;
using MyApp.Data.Repositories;
using System.Threading.Tasks;

namespace MyApp.Tests.Integration;

[TestFixture]
public class CreatePageTests
{
    private readonly Mock<IActivityRepository> _repoMock;
    private ActivityCreatePageModel _page; // Assuming the page model is named Create.cshtml.cs

    [SetUp]
    public void Setup()
    {
        _repoMock = new Mock<IActivityRepository>();
        var activity = new Activity
        {
            ActivityId      = Guid.NewGuid(),
            ProjectId       = Guid.NewGuid(),
            ProjectMemberId = Guid.NewGuid(),
            Name            = "Test",
            Description     = "desc",
            ActiveFlag      = 1,
            SystemDeleteFlag='N',
            CreatedDateTime  = DateTime.UtcNow,
            CreatedByUser    = "System",
            CreatedByProgram = "CreatePage"
        };
        _repoMock.Setup(r => r.AddAsync(It.Is<Activity>(a => a.ActivityId == activity.ActivityId)))
                  .Returns(Task.CompletedTask);

        // The page model constructor receives the repository.
        _page = new ActivityCreatePageModel(_repoMock.Object);
    }

    [Test]
    public async Task OnPost_WithValidModel_AddsEntity()
    {
        var vm = new ActivityCreateViewModel
        {
            ProjectId      = Guid.NewGuid().ToString(),
            ProjectMemberId= Guid.NewGuid().ToString(),
            Name           = "New",
            Description    = "desc"
        };

        // Act
        var result = await _page.OnPostAsync(vm);

        // Assert
        Assert.IsType<RedirectToPageResult>(result);
        _repoMock.Verify(r => r.AddAsync(It.IsAny<Activity>()), Times.Once);
    }

    [Test]
    public async Task OnGet_DisplaysEmptyModel()
    {
        var result = await _page.OnGetAsync();
        Assert.IsType<PageHandledEventArgs>((EventArgs)result);
        // The model is populated with default empty viewmodel.
        Assert.NotNull(_page.Model);
    }
}
