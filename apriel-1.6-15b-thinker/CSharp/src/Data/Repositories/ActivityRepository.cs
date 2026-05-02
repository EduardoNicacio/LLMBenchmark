// src/Data/Repositories/ActivityRepository.cs
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Data.Repositories;

public interface IActivityRepository : IRepository<Activity>
{
    Task<List<ReadActivityDto>> GetAllWithDetailsAsync();
}

public class ActivityRepository : GenericRepository<Activity>, IActivityRepository
{
    public ActivityRepository(IDbContextFactory<DbContext> dbContextFactory)
        : base(dbContextFactory) { }

    public async Task<List<ReadActivityDto>> GetAllWithDetailsAsync()
    {
        var activities = await GetAllAsync();
        return activities.Select(ActivityToDto).ToList();
    }

    private static ReadActivityDto ActivityToDto(Activity activity) =>
        new ReadActivityDto
        {
            ActivityId   = activity.ActivityId,
            ProjectId    = activity.ProjectId,
            ProjectMemberId = activity.ProjectMemberId,
            Name         = activity.Name,
            Description  = activity.Description,
            StartDate    = activity.StartDate,
            TargetDate   = activity.TargetDate,
            EndDate      = activity.EndDate,
            ProgressStatus = activity.ProgressStatus,
            ActivityPoints = activity.ActivityPoints,
            Priority     = activity.Priority,
            Risk         = activity.Risk,
            Tags         = activity.Tags,
            ActiveFlag   = activity.ActiveFlag,
            SystemDeleteFlag = activity.SystemDeleteFlag,
            CreatedDateTime  = activity.CreatedDateTime,
            CreatedByUser    = activity.CreatedByUser,
            CreatedByProgram = activity.CreatedByProgram,
            UpdatedDateTime  = activity.UpdatedDateTime,
            UpdatedByUser    = activity.UpdatedByUser,
            UpdatedByProgram = activity.UpdatedByProgram,
            SystemTimestamp = activity.SystemTimestamp
        };
}
