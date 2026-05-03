// ActivityListViewModel.cs
using System;
using System.Collections.Generic;

namespace YourApp.Web.ViewModels;

public sealed class ActivityListViewModel
{
    public IReadOnlyList<ActivityReadDto> Items { get; set; } = null!;
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public int TotalCount { get; set; }
}
