// src/Data/Interfaces/IRepository.cs
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyApp.Data.Interfaces;

public interface IRepository<T> where T : class
{
    Task<IReadOnlyList<T>> GetAllAsync();
    Task<T?> GetByIdAsync(Guid id);
    Task AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(T entity);
}
