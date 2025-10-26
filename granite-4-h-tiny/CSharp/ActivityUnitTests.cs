public class ViewModelTests
{
    [Test]
    public void CreateViewModel_ShouldMapCorrectly()
    {
        var viewModel = new CreateDto();
        viewModel.Name = "Test Activity";
        viewModel.Description = "This is a test activity.";

        var model = AutoMapper.Mapper.Map<Activity>(viewModel);
        
        Assert.AreEqual("Test Activity", model.Name);
        Assert.AreEqual("This is a test activity.", model.Description);
    }
}
