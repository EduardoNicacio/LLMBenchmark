using Microsoft.EntityFrameworkCore;
using ActivityApp.Models;

namespace ActivityApp
{
    public class ActivityDbContext : DbContext
    {
        public ActivityDbContext(DbContextOptions<ActivityDbContext> options) : base(options) { }

        public DbSet<Activity> Activities => Set<Activity>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Activity>(entity =>
            {
                entity.HasKey(e => e.ActivityId);
                entity.Property(e => e.SystemTimestamp).IsRowVersion();
            });
        }
    }
}
