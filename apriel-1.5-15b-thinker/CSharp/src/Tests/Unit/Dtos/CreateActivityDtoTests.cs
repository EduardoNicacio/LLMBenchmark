// Tests/Dtos/CreateActivityDtoTests.cs
using NUnit.Framework;
using MyApp.Data.Dtos;

namespace MyApp.Tests.Dtos;

[TestFixture]
public class CreateActivityDtoTests
{
    [Test]
    public void Should_validate_required_properties()
    {
        var dto = new CreateActivityDto();
        // Force violation by leaving required fields empty.
        Assert.Throws<InvalidOperationException>(() => dto.Validate());
    }

    [Test]
    public void Should_pass_validation_with_valid_data()
    {
        var dto = new CreateActivityDto
        {
            ProjectId      = Guid.NewGuid().ToString(),
            ProjectMemberId= Guid.NewGuid().ToString(),
            Name           = "New Activity",
            Description    = "A short description.",
            ActiveFlag     = 1,
            SystemDeleteFlag='N',
            CreatedByUser   = "John Doe",
            CreatedByProgram="MyApp"
        };

        var result = dto.Validate();
        Assert.IsTrue(result.IsValid);
    }
}
