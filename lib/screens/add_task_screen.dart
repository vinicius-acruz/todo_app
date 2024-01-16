import 'package:flutter/material.dart';
import 'package:todoey_flutter/models/task_data.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late String typedText;
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: messageTextController,
                onChanged: (value) {
                  typedText = value;
                },
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blue, // Set text color to blue
                  fontWeight: FontWeight.bold, // Set text to bold
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                color: Colors.lightBlueAccent,
                child: TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      final String enteredText = typedText;
                      Provider.of<TaskData>(context, listen: false)
                          .addTask(enteredText);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
