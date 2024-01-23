import 'package:flutter/material.dart';
import 'package:todoey_flutter/models/task.dart';
import 'package:todoey_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_data.dart';

class TasksList extends StatefulWidget {
  final bool showDone;

  TasksList({required this.showDone});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final GlobalKey<AnimatedListState> _tasksListKey =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _completedTasksListKey =
      GlobalKey<AnimatedListState>();

  GlobalKey<AnimatedListState> get _listKey =>
      widget.showDone ? _completedTasksListKey : _tasksListKey;

  @override
  void initState() {
    super.initState();
    // Set up the onTaskAdded callback
    Provider.of<TaskData>(context, listen: false).onTaskAdded = _onTaskAdded;
  }

  void _onTaskAdded(int index) {
    _listKey.currentState?.insertItem(index);
  }

  @override
  void dispose() {
    // Clean up the callback when the widget is removed
    Provider.of<TaskData>(context, listen: false).onTaskAdded = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: Provider.of<TaskData>(context).currentFilter,
                icon: const Icon(Icons.filter_list),
                onChanged: (String? newValue) {
                  final taskData =
                      Provider.of<TaskData>(context, listen: false);
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
          ],
        ),
        Expanded(
          child: Consumer<TaskData>(
            builder: (context, taskData, child) {
              List<Task> tasksToShow =
                  widget.showDone ? taskData.completedTasks : taskData.tasks;

              return AnimatedList(
                key: _listKey,
                initialItemCount: tasksToShow.length,
                itemBuilder: (context, index, animation) {
                  final task = tasksToShow[index];
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
                        _updateItem(index);
                      },
                      longPressCallback: () {
                        _updateItem(index);
                      },
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

  void _updateItem(int index) {
    final taskData = Provider.of<TaskData>(context, listen: false);
    final taskToggle = widget.showDone
        ? taskData.completedTasks[index]
        : taskData.tasks[index];

    // This will move the task to the completed list or back to the tasks list
    taskData.updateTask(taskToggle);

    // Animates the removal of the item from the current list
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: TaskTile(
          taskTitle: taskToggle.name,
          isChecked: taskToggle.isDone,
          dueDate: taskToggle.dueDate,
          priority: taskToggle.priority,
          reminderTime: taskToggle.reminderTime,
          // Other parameters if needed
        ),
      ),
    );

    // If a task is moved to another list, you should insert it there
    if (widget.showDone != taskToggle.isDone) {
      final otherList =
          widget.showDone ? taskData.tasks : taskData.completedTasks;
      final otherListKey =
          widget.showDone ? _tasksListKey : _completedTasksListKey;
      otherListKey.currentState?.insertItem(otherList.length - 1);
    }
  }
}
