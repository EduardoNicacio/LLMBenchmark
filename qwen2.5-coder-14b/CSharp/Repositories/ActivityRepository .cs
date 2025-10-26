using System.Linq;
using System.Threading.Tasks;

namespace ActivityManagement.Repositories
{
    public class ActivityRepository : GenericRepository<Activity>, IActivityRepository
    {
        private readonly ApplicationDbContext _context;

        public ActivityRepository(ApplicationDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<ReadActivityDto>> GetAllAsync()
        {
            return await _dbSet.Select(a => new ReadActivityDto
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
            }).ToListAsync();
        }

        public async Task<Activity> GetByIdAsync(Guid id)
        {
            return await _dbSet.FindAsync(id);
        }

        public async Task AddAsync(Activity activity)
        {
            await _dbSet.AddAsync(activity);
        }

        public void Update(Activity activity)
        {
            _context.Entry(activity).State = EntityState.Modified;
        }

        public void Delete(Activity activity)
        {
            _dbSet.Remove(activity);
        }
    }
}
