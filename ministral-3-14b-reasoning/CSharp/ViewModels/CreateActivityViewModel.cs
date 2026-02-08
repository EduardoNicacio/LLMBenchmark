using Microsoft.AspNetCore.Mvc;

public class CreateActivityViewModel
{
    [BindProperty]
    public CreateActivityDto Activity { get; set; } = new();
}
