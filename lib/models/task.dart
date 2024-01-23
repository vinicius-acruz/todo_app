class Task {
  final String name;
  bool isDone;
  DateTime? dueDate; // Optional due date
  String priority; // High, Medium, Low
  DateTime? reminderTime; // Optional reminder time
  int order;

  Task(
      {required this.name,
      this.isDone = false,
      this.dueDate,
      this.priority = 'Low',
      this.reminderTime,
      required this.order});

  void toggleDone() {
    isDone = !isDone;
  }
}
