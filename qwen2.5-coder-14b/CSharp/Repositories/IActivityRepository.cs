using System;
using System.Linq;
using System.Threading.Tasks;

namespace ActivityManagement.Repositories
{
    public interface IActivityRepository : IGenericRepository<Activity>
    {
        Task<List<ReadActivityDto>> GetAllAsync();
        Task<Activity> GetByIdAsync(Guid id);
        Task AddAsync(Activity activity);
        void Update(Activity activity);
        void Delete(Activity activity);
    }
}
