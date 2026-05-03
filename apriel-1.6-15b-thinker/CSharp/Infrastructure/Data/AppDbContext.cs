using Microsoft.EntityFrameworkCore;
using YourApp.Domain.Entities;

namespace YourApp.Infrastructure.Data
{
    /// <summary>
    /// Main application DbContext.
    /// </summary>
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Activity> Activities => Set<Activity>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Concurrency token
            modelBuilder.Entity<Activity>()
                .Property(a => a.SystemTimestamp)
                .IsRowVersion();

            // Primary key generation
            modelBuilder.Entity<Activity>()
                .Property(a => a.ActivityId)
                .HasValueGeneratedOnAdd()
                .HasDefaultValueSql("NEWSEQUENTIALID()");

            // Default values for non‑identity columns
            modelBuilder.Entity<Activity>()
                .Property(a => a.SystemDeleteFlag)
                .HasDefaultValue("N");

            modelBuilder.Entity<Activity>()
                .Property(a => a.ActiveFlag)
                .HasDefaultValue(1);

            modelBuilder.Entity<Activity>()
                .Property(a => a.CreatedDateTime)
                .HasDefaultValueSql("SYSUTCDATETIME()");
        }
    }
}
