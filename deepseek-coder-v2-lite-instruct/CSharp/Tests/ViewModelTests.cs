using NUnit.Framework;
using YourNamespace.ViewModels;
using System;

namespace YourNamespace.Tests
{
    [TestFixture]
    public class ViewModelTests
    {
        [Test]
        public void ActivityCreateViewModel_PropertiesAreSetCorrectly()
        {
            var viewModel = new ActivityCreateViewModel
            {
                Activity = new ActivityCreateDto
                {
                    ProjectId = Guid.NewGuid(),
                    // Set other properties...
                }
            };

            Assert.NotNull(viewModel);
            Assert.NotNull(viewModel.Activity);
            Assert.IsInstanceOf<Guid>(viewModel.Activity.ProjectId);
            // Add more assertions for other properties...
        }
    }
}
