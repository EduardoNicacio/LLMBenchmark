using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ProjectManagement.Models;

namespace ProjectManagement.Data.Repositories
{
    public class ActivityRepository : GenericRepository<Activity>, IActivityRepository
    {
        public ActivityRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Activity>> GetActivitiesByProjectIdAsync(Guid projectId)
        {
            return await _dbSet.Where(a => a.ProjectId == projectId && a.SystemDeleteFlag == "N")
                .OrderByDescending(a => a.CreatedDateTime)
                .ToListAsync();
        }

        public async Task<IEnumerable<Activity>> GetActiveActivitiesAsync()
        {
            return await _dbSet.Where(a => a.ActiveFlag && a.SystemDeleteFlag == "N")
                .OrderByDescending(a => a.CreatedDateTime)
                .ToListAsync();
        }

        public async Task UpdateProgressStatusAsync(Guid activityId, byte progressStatus)
        {
            var activity = await _dbSet.FindAsync(activityId);
            if (activity != null)
            {
                activity.ProgressStatus = progressStatus;
                activity.UpdatedDateTime = DateTime.UtcNow;
                activity.UpdatedByUser = "System"; // Or get from user context
                activity.UpdatedByProgram = "WebApp";

                await _context.SaveChangesAsync();
            }
        }
    }
}
