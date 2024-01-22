import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class TaskTile extends StatelessWidget {
  final bool? isChecked;
  final String? taskTitle;
  final DateTime? dueDate;
  final String? priority;
  final DateTime? reminderTime;
  final void Function(bool?)? checkboxCallback;
  final void Function()? longPressCallback;

  TaskTile({
    this.isChecked,
    this.taskTitle,
    this.dueDate,
    this.priority,
    this.reminderTime,
    this.checkboxCallback,
    this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskTitle!,
        style: TextStyle(
          decoration: isChecked == true ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (priority != null)
            Row(
              children: [
                const Text('Priority: '),
                CircleAvatar(
                  radius: 5,
                  backgroundColor: priority == 'Low'
                      ? Colors.green
                      : priority == 'Medium'
                          ? Colors.yellow
                          : Colors.red,
                ),
              ],
            ),
          if (dueDate != null)
            Text('Due: ${DateFormat('yyyy-MM-dd').format(dueDate!)}'),
          if (reminderTime != null)
            Text(
                'Reminder: ${DateFormat('yyyy-MM-dd – HH:mm').format(reminderTime!)}'),
        ],
      ),
      trailing: Checkbox(
        value: isChecked,
        onChanged: checkboxCallback,
        activeColor: Colors.lightBlueAccent,
      ),
      onLongPress: longPressCallback,
    );
  }
}
