// EF Core Activity Repository Implementation
/// <summary>
/// Concrete implementation of the IGenericRepository for Activity entities.
/// </summary>
public class ActivityRepository : IGenericRepository<ActivityModel>
{
    private readonly ApplicationDbContext _context;

    public ActivityRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<ActivityModel> GetByIdAsync(Guid id)
    {
        return await _context.Activities.FindAsync(id);
    }

    public async Task<IEnumerable<ActivityModel>> GetAllAsync()
    {
        return await _context.Activities.ToListAsync();
    }

    public async Task AddAsync(ActivityModel entity)
    {
        await _context.Activities.AddAsync(entity);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(ActivityModel entity)
    {
        _context.Activities.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(ActivityModel entity)
    {
        _context.Activities.Remove(entity);
        await _context.SaveChangesAsync();
    }

    public async Task<bool> ExistsAsync(Guid id)
    {
        return await _context.Activities.AnyAsync(x => x.ActivityId == id);
    }
}
