using Microsoft.EntityFrameworkCore;
using MyApp.Models;

namespace MyApp.Data
{
    // EF Core DbContext for the application.
    public class MyAppContext : DbContext
    {
        public MyAppContext(DbContextOptions<MyAppContext> options)
        : base(options) { }

        public DbSet<Activity> Activities { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure table and key mapping if needed.
            modelBuilder.Entity<Activity>().ToTable("dbo.Activity");
        }
    }
}