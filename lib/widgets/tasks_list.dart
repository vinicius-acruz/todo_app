import 'package:flutter/material.dart';
import 'package:todoey_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_data.dart';

class TasksList extends StatefulWidget {
  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
        Expanded(
          child: Consumer<TaskData>(
            builder: (context, taskData, child) {
              return AnimatedList(
                key: _listKey,
                initialItemCount: taskData.taskCount,
                itemBuilder: (context, index, animation) {
                  final task = taskData.tasks[index];
                  return SlideTransition(
                    position: animation.drive(
                      Tween(
                        begin: Offset(-1, 0),
                        end: Offset(0, 0),
                      ),
                    ),
                    child: TaskTile(
                      taskTitle: task.name,
                      isChecked: task.isDone,
                      dueDate: task.dueDate, // Pass the dueDate to TaskTile
                      priority: task.priority, // Pass the priority to TaskTile
                      reminderTime: task
                          .reminderTime, // Pass the reminderTime to TaskTile
                      checkboxCallback: (checkboxState) {
                        taskData.updateTask(task);
                        // If you want to remove the item from the list upon checkbox toggle
                        if (task.isDone) {}
                      },
                      longPressCallback: () {},
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // void _removeItem(int index) {
  //   final taskData = Provider.of<TaskData>(context, listen: false);
  //   final removedTask = taskData.tasks[index];

  //   // Remove the task from the taskData
  //   taskData.deleteTask(removedTask);

  //   // Animates the removal of the item
  //   _listKey.currentState?.removeItem(
  //     index,
  //     (context, animation) => SizeTransition(
  //       sizeFactor: animation,
  //       child: TaskTile(
  //         taskTitle: removedTask.name,
  //         isChecked: removedTask.isDone,
  //         dueDate: removedTask.dueDate,
  //         priority: removedTask.priority,
  //         reminderTime: removedTask.reminderTime,
  //         // Other parameters if needed
  //       ),
  //     ),
  //   );
  // }
}
