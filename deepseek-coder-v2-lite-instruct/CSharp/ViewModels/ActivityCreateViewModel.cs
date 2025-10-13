using System;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;

namespace YourNamespace.ViewModels
{
    public class ActivityCreateViewModel
    {
        public ActivityCreateDto Activity { get; set; }
        public List<SelectListItem> ProjectMembers { get; set; } // Assuming you need to select a project member
    }
}
