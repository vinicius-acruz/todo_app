class Task {
  final String name;
  bool isDone;
  DateTime? dueDate; // Optional due date
  String priority; // High, Medium, Low
  DateTime? reminderTime; // Optional reminder time

  Task(
      {required this.name,
      this.isDone = false,
      this.dueDate,
      this.priority = 'Low',
      this.reminderTime});

  void toggleDone() {
    isDone = !isDone;
  }
}
