// src/Data/Repositories/GenericRepository.cs
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Data.Repositories;

public class GenericRepository<T> : IRepository<T>
    where T : class
{
    protected readonly IDbContextFactory<DbContext> _dbContextFactory;

    public GenericRepository(IDbContextFactory<DbContext> dbContextFactory)
        => _dbContextFactory = dbContextFactory ?? throw new ArgumentNullException(nameof(dbContextFactory));

    public async Task<IReadOnlyList<T>> GetAllAsync()
        => await _GetContext().GetAsync<T>();

    public Task<T?> GetByIdAsync(Guid id) =>
        _GetContext()
            .Set<T>()
            .FirstOrDefaultAsync(t => t.Equals(id));

    public async Task AddAsync(T entity)
    {
        var ctx = await _GetContext();
        ctx.Add(entity);
        await ctx.SaveChangesAsync();
    }

    public async Task UpdateAsync(T entity)
    {
        var ctx = await _GetContext();
        ctx.Update(entity);
        await ctx.SaveChangesAsync();
    }

    public async Task DeleteAsync(T entity)
    {
        var ctx = await _GetContext();
        ctx.Remove(entity);
        await ctx.SaveChangesAsync();
    }

    private async Task<DbContext> _GetContext()
        => await _dbContextFactory.CreateInstanceAsync();

    // Helper to query the specific DbSet<T>
    protected internal async Task<DbContext> GetContextAsync()
        => await _GetContext();
}
