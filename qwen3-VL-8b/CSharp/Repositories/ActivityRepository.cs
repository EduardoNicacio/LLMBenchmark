// EF Core Activity Repository
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace YourProject.Repositories
{
    public class ActivityRepository : GenericRepository<Activity>, IActivityRepository
    {
        public ActivityRepository(DbContext context) : base(context) { }

        public async Task<IEnumerable<Activity>> GetByProjectIdAsync(Guid projectId)
        {
            return await _dbSet
                .Where(a => a.ProjectId == projectId)
                .ToListAsync();
        }

        public async Task<IEnumerable<ReadActivityDto>> GetReadDtoListAsync()
        {
            return await _dbSet
                .Select(a => new ReadActivityDto
                {
                    ActivityId = a.ActivityId,
                    ProjectId = a.ProjectId,
                    ProjectMemberId = a.ProjectMemberId,
                    Name = a.Name,
                    Description = a.Description,
                    StartDate = a.StartDate,
                    TargetDate = a.TargetDate,
                    EndDate = a.EndDate,
                    ProgressStatus = a.ProgressStatus,
                    ActivityPoints = a.ActivityPoints,
                    Priority = a.Priority,
                    Risk = a.Risk,
                    Tags = a.Tags,
                    ActiveFlag = a.ActiveFlag,
                    SystemDeleteFlag = a.SystemDeleteFlag,
                    CreatedDateTime = a.CreatedDateTime,
                    CreatedByUser = a.CreatedByUser,
                    CreatedByProgram = a.CreatedByProgram,
                    UpdatedDateTime = a.UpdatedDateTime,
                    UpdatedByUser = a.UpdatedByUser,
                    UpdatedByProgram = a.UpdatedByProgram
                })
                .ToListAsync();
        }
    }

    public interface IActivityRepository : IGenericRepository<Activity>
    {
        Task<IEnumerable<Activity>> GetByProjectIdAsync(Guid projectId);
        Task<IEnumerable<ReadActivityDto>> GetReadDtoListAsync();
    }
}
