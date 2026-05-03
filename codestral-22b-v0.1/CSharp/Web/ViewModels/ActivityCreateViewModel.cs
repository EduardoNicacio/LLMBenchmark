// ActivityCreateViewModel.cs
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.ComponentModel.DataAnnotations;

namespace YourApp.Web.ViewModels;

public sealed class ActivityCreateViewModel
{
    // Properties from ActivityCreateDto...

    public SelectList ProgressStatusOptions { get; set; } = new(new[] { new SelectListItem("Low", "1"), new SelectListItem("Medium", "2"), new SelectListItem("High", "3") });
    public SelectList PriorityOptions { get; set; } = new(new[] { new SelectListItem("Low", "1"), new SelectListItem("Medium", "2"), new SelectListItem("High", "3") });
    public SelectList RiskOptions { get; set; } = new(new[] { new SelectListItem("Low", "1"), new SelectListItem("Medium", "2"), new SelectListItem("High", "3") });
}
