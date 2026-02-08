using System;
using System.Collections.Generic;
using System.Threading.Tasks;

public interface IActivityRepository : IRepository<Activity>
{
    Task<IEnumerable<Activity>> GetActivitiesByProjectIdAsync(Guid projectId);
}
