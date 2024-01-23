import 'package:flutter/material.dart';
import 'package:todoey_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: Provider.of<TaskData>(context).currentFilter,
            icon: const Icon(Icons.filter_list),
            onChanged: (String? newValue) {
              final taskData = Provider.of<TaskData>(context, listen: false);
              if (newValue != null) {
                switch (newValue) {
                  case 'All':
                    taskData.sortByOrder();
                    break;
                  case 'Due Date':
                    taskData.sortByDueDate();
                    break;
                  case 'Priority':
                    taskData.sortByPriority();
                    break;
                  // ... potentially other cases ...
                }
                // Update the current filter
                taskData.currentFilter = newValue;
              }
            },
            items: <String>['All', 'Due Date', 'Priority']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(child: Consumer<TaskData>(
          builder: (context, taskData, child) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final task = taskData.tasks[index];
                return TaskTile(
                  taskTitle: task.name,
                  isChecked: task.isDone,
                  dueDate: task.dueDate, // Pass the dueDate to TaskTile
                  priority: task.priority, // Pass the priority to TaskTile
                  reminderTime:
                      task.reminderTime, // Pass the reminderTime to TaskTile
                  checkboxCallback: (checkboxState) {
                    taskData.updateTask(task);
                  },
                  longPressCallback: () {
                    taskData.deleteTask(task);
                  },
                );
              },
              itemCount: taskData.taskCount,
            );
          },
        )),
      ],
    );
  }
}
