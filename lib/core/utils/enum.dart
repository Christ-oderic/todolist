enum TaskStatus { todo, doing, done }

enum TaskPriority { faible, normal, urgent }

String taskStatusToString(TaskStatus status) {
  switch (status) {
    case TaskStatus.todo:
      return 'todo';
    case TaskStatus.doing:
      return 'doing';
    case TaskStatus.done:
      return 'done';
  }
}

TaskStatus stringToTaskStatus(String status) {
  switch (status) {
    case 'todo':
      return TaskStatus.todo;
    case 'doing':
      return TaskStatus.doing;
    case 'done':
      return TaskStatus.done;
    default:
      return TaskStatus.todo;
  }
}

String taskPriorityToString(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.faible:
      return 'faible';
    case TaskPriority.normal:
      return 'normal';
    case TaskPriority.urgent:
      return 'urgent';
  }
}

TaskPriority stringToTaskPriority(String priority) {
  switch (priority) {
    case 'faible':
      return TaskPriority.faible;
    case 'normal':
      return TaskPriority.normal;
    case 'urgent':
      return TaskPriority.urgent;
    default:
      return TaskPriority.normal;
  }
}
