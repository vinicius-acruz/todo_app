import 'package:flutter/foundation.dart';
import 'package:todoey_flutter/models/task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy Lemon'),
    Task(name: 'Buy Orange'),
    Task(name: 'Buy Strawberries'),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  } // Secure that the tasks list wont be modified

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String taskName,
      {DateTime? dueDate, String priority = 'Low', DateTime? reminderTime}) {
    final newTask = Task(
      name: taskName,
      dueDate: dueDate,
      priority: priority,
      reminderTime: reminderTime,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }
}
