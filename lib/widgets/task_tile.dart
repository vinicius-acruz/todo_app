import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool? isChecked;
  final String? taskTitle;
  final void Function(bool?)? checkboxCallback;
  final void Function()? longPressCallback;

  TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        taskTitle!,
        style: TextStyle(
          decoration: isChecked == true ? TextDecoration.lineThrough : null,
        ),
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

// class TaskCheckBox extends StatelessWidget {
//   final bool? checkboxState;
//   final void Function(bool?)? toggleCheckboxState;
//
//   TaskCheckBox(
//       {required this.checkboxState, required this.toggleCheckboxState});
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
