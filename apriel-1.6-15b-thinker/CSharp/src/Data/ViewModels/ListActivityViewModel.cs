// src/ViewModels/ListActivityViewModel.cs
using System.Collections.Generic;

namespace MyApp.Pages.ViewModels;

public class ListActivityViewModel
{
    public IEnumerable<ReadActivityDto> Activities { get; set; } = Enumerable.Empty<ReadActivityDto>();

    public int PageNumber { get; set; }

    public int PageSize { get; set; } = 10;
}
