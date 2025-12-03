import 'package:flutter/foundation.dart';
import 'package:tasqmaster/src/models/task.dart';
import 'task_list_view_model.dart';

class TaskDetailViewModel extends ChangeNotifier {
  final Task _task;
  final TaskListViewModel? _taskListViewModel;

  TaskDetailViewModel({
    required Task task,
    TaskListViewModel? taskListViewModel,
  }) : _task = task,
       _taskListViewModel = taskListViewModel;

  Task get task => _task;

  String get formattedCreatedTime {
    return '${_task.createdAt.day}/${_task.createdAt.month}/${_task.createdAt.year} ${_task.createdAt.hour.toString().padLeft(2, '0')}:${_task.createdAt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> markCompleted() async {
    if (_task.status == TaskStatus.completed) {
      return;
    }

    final updatedTask = _task.copyWith(status: TaskStatus.completed);

    if (_taskListViewModel != null) {
      await _taskListViewModel.updateTask(updatedTask);
    }

    notifyListeners();
  }
}
