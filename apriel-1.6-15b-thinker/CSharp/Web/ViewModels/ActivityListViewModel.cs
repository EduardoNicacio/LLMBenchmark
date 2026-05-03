using YourApp.Application.DTOs;

namespace YourApp.Web.ViewModels
{
    /// <summary>
    /// Paginated view model for the Index page.
    /// </summary>
    public sealed record ActivityListViewModel(
        IReadOnlyList<ActivityReadDto> Items,
        int PageNumber,
        int PageSize,
        int TotalCount
    );
}
