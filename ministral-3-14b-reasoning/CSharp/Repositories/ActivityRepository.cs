using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

public class ActivityRepository : Repository<Activity>, IActivityRepository
{
    public ActivityRepository(DbContext context) : base(context)
    {
    }

    public async Task<IEnumerable<Activity>> GetActivitiesByProjectIdAsync(Guid projectId)
    {
        return await _dbSet.Where(a => a.ProjectId == projectId).ToListAsync();
    }
}
