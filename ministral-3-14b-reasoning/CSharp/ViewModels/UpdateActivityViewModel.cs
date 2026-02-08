using Microsoft.AspNetCore.Mvc;

public class UpdateActivityViewModel
{
    [BindProperty]
    public UpdateActivityDto Activity { get; set; } = new();
}
