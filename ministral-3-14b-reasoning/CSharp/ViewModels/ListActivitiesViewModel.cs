using System.Collections.Generic;

public class ListActivitiesViewModel
{
    public IEnumerable<ReadActivityDto> Activities { get; set; } = Enumerable.Empty<ReadActivityDto>();
}
