// CreateViewModel.cs, UpdateViewModel.cs, ListViewModel.cs
using System.ComponentModel.DataAnnotations;

// Base ViewModel could be common for all operations.
public class ViewModelBase
{
    [Required] public string Name { get; set; }
    [Required] public string Description { get; set; }
    // Other properties would depend on the operation...
}

// CreateViewModel inherits from ViewModelBase and adds StartDate, TargetDate, etc.
// UpdateViewModel also inherits but might omit some fields not editable in edit mode.

public class ListViewModel
{
    public List<ReadDto> Activities { get; set; } // For details view linking

    // Additional properties could include pagination info...
}
