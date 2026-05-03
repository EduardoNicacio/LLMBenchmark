namespace YourApp.Tests.Unit;

[TestFixture]
public class ActivityUnitTests
{
    [Test]
    public void ActivityEntity_ShouldHaveNonNullableSystemTimestamp()
    {
        var activity = new Activity();
        Assert.That(activity.SystemTimestamp, Is.Not.Null);
    }

    [Test]
    public void ActivityCreateDto_ValidData_ShouldPassValidation()
    {
        var dto = new ActivityCreateDto { /* Valid data */ };
        var validator = new Validator();
        var result = validator.TryValidateObject(dto, new(), null!);
        Assert.That(result, Is.True);
    }
}
