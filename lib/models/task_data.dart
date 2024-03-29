import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoey_flutter/models/task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      name: 'Buy Lemon',
      dueDate: DateTime(2024, 1, 20), // Example due date
      priority: 'High', // Example priority
      reminderTime: DateTime(2024, 1, 19, 8, 30), // Example reminder time
      order: 1,
    ),
    Task(
      name: 'Buy Orange',
      dueDate: DateTime(2024, 1, 22), // Another example due date
      priority: 'Medium', // Another example priority
      reminderTime:
          DateTime(2024, 1, 21, 9, 0), // Another example reminder time
      order: 2,
    ),
    Task(
      name: 'Buy Strawberries',
      dueDate: DateTime(2024, 1, 25), // Another example due date
      priority: 'Low', // Another example priority
      reminderTime: null, // No reminder time set for this task
      order: 3,
    ),
    Task(
      name: 'Attend Yoga Class',
      dueDate: DateTime(2024, 1, 26),
      priority: 'High',
      reminderTime: DateTime(2024, 1, 26, 6, 0),
      order: 4,
    ),
    Task(
      name: 'Finish Flutter Project',
      dueDate: DateTime(2024, 1, 30),
      priority: 'High',
      reminderTime: DateTime(2024, 1, 29, 20, 0),
      order: 5,
    ),
    Task(
      name: 'Call the Dentist',
      dueDate: null, // No due date for this task
      priority: 'Medium',
      reminderTime: null, // No reminder time for this task
      order: 6,
    ),
    Task(
      name: 'Grocery Shopping',
      dueDate: DateTime(2024, 1, 27),
      priority: 'Medium',
      reminderTime: DateTime(2024, 1, 27, 10, 0),
      order: 7,
    ),
    Task(
      name: 'Car Service Appointment',
      dueDate: DateTime(2024, 2, 1),
      priority: 'Low',
      reminderTime: DateTime(2024, 2, 1, 9, 0),
      order: 8,
    ),
  ];

  // List for completed tasks
  List<Task> _completedTasks = [];

// Current filter
  String currentFilter = 'All';

// Method to sort tasks by the 'order' attribute
  void sortByOrder() {
    _tasks.sort((a, b) {
      // Compare the order of each task
      return a.order.compareTo(b.order);
    });

    notifyListeners();
  }

  void sortByDueDate() {
    _tasks.sort((a, b) {
      // If both dueDates are null, they are considered equal
      if (a.dueDate == null && b.dueDate == null) {
        return 0;
      }
      // If only a's dueDate is null, a is moved towards the end
      if (a.dueDate == null) {
        return 1;
      }
      // If only b's dueDate is null, b is moved towards the end
      if (b.dueDate == null) {
        return -1;
      }
      // If both dueDates are non-null, they are compared normally
      return a.dueDate!.compareTo(b.dueDate!);
    });
    notifyListeners();
  }

  // Method to sort tasks by priority
  void sortByPriority() {
    // Define the order for the priorities, reversed
    const priorityOrder = {
      'High': 1, // Red
      'Medium': 2, // Yellow
      'Low': 3, // Green
    };

    _tasks.sort((a, b) {
      // Compare based on the defined priority order
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });

    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  } // Secure that the tasks list wont be modified

  UnmodifiableListView<Task> get completedTasks {
    return UnmodifiableListView(_completedTasks);
  } // Secure that the tasks list wont be modified

  int get taskCount {
    return _tasks.length;
  }

  int get completedTaskCount {
    return _completedTasks.length;
  }

  // Add a callback for when a task is added
  Function(int)? onTaskAdded;

  void addTask(String taskName,
      {DateTime? dueDate, String priority = 'Low', DateTime? reminderTime}) {
    final newTask = Task(
      name: taskName,
      dueDate: dueDate,
      priority: priority,
      reminderTime: reminderTime,
      order: _tasks.length,
    );
    _tasks.add(newTask);
    // After adding the task, notify the listener
    int newIndex = tasks.length - 1; // Get the index of the new task
    if (onTaskAdded != null) {
      onTaskAdded!(newIndex);
    }

    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    if (task.isDone) {
      // Move the task to the completed tasks list
      _completedTasks.add(task);
      _tasks.remove(task);
    } else {
      // If task is marked as not done, move it back to the main tasks list
      _tasks.add(task);
      _completedTasks.remove(task);
    }
    notifyListeners();
  }
}
