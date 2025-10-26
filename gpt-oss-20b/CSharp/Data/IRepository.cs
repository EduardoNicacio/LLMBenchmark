// File: Data/IRepository.cs
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace MyApp.Data;

/// <summary>
/// Generic repository contract.
/// </summary>
public interface IRepository<T> where T : class
{
    Task<T?> GetAsync(Guid id);
    Task<IEnumerable<T>> GetAllAsync();
    Task AddAsync(T entity);
    void Update(T entity);
    void Delete(T entity);

    // Optional: query by predicate
    Task<IEnumerable<T>> FindAsync(Expression<Func<T, bool>> predicate);
}
