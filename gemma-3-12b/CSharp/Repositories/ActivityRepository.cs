using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using MyApplication.Models;
using MyApplication.DTOs;

namespace MyApplication.Repositories
{
    public interface IActivityRepository
    {
        List<Activity> Get();
        Activity? Get(Guid id);
        void Add(ActivityCreateDto activityCreateDto);
        void Update(ActivityUpdateDto activityUpdateDto);
        void Delete(Guid id);
    }

    public class ActivityRepository : IActivityRepository
    {
        private readonly MyApplicationDbContext _context;

        public ActivityRepository(MyApplicationDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public List<Activity> Get()
        {
            return _context.Activities.ToList();
        }

        public Activity? Get(Guid id)
        {
            return _context.Activities.FirstOrDefault(a => a.ActivityId == id);
        }

        public void Add(ActivityCreateDto activityCreateDto)
        {
            var newActivity = new Activity
            {
                ProjectId = activityCreateDto.ProjectId,
                ProjectMemberId = activityCreateDto.ProjectMemberId,
                Name = activityCreateDto.Name,
                Description = activityCreateDto.Description,
                StartDate = activityCreateDto.StartDate,
                TargetDate = activityCreateDto.TargetDate,
                ActiveFlag = activityCreateDto.ActiveFlag,
                CreatedDateTime = DateTime.Now,
                CreatedByUser = "System", // Replace with actual user information
                CreatedByProgram = "ActivityService"
            };

            _context.Activities.Add(newActivity);
            _context.SaveChanges();
        }

        public void Update(ActivityUpdateDto activityUpdateDto)
        {
            var existingActivity = _context.Activities.FirstOrDefault(a => a.ActivityId == activityUpdateDto.ActivityId);
            if (existingActivity != null)
            {
                _context.Entry(existingActivity).CurrentValues.SetValues(new Activity
                {
                    EndDate = activityUpdateDto.EndDate,
                    ProgressStatus = activityUpdateDto.ProgressStatus,
                    ActivityPoints = activityUpdateDto.ActivityPoints,
                    Priority = activityUpdateDto.Priority,
                    Risk = activityUpdateDto.Risk,
                    Tags = activityUpdateDto.Tags,
                    UpdatedDateTime = DateTime.Now,
                    UpdatedByUser = "System",
                    UpdatedByProgram = "ActivityService"
                });

                _context.SaveChanges();
            }
        }

        public void Delete(Guid id)
        {
            var activityToDelete = _context.Activities.FirstOrDefault(a => a.ActivityId == id);
            if (activityToDelete != null)
            {
                _context.Activities.Remove(activityToDelete);
                _context.SaveChanges();
            }
        }
    }
}
