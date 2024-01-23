import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoey_flutter/models/task.dart';
import 'package:todoey_flutter/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/widgets/voice_control.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String typedText = '';
  DateTime? selectedDueDate;
  DateTime? selectedReminderTime;
  String selectedPriority = 'Low';
  final messageTextController = TextEditingController();

  void updateTypedText(String newText) {
    setState(() {
      typedText = newText;
      messageTextController.text = newText; // Update the controller text
    });
  }

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
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SingleChildScrollView(
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
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: TextField(
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
                      ),
                      const SizedBox(height: 20.0),
                      // Priority Dropdown
                      Row(
                        children: [
                          const Text('Priority: '),
                          DropdownButton<String>(
                            value: selectedPriority,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPriority = newValue!;
                              });
                            },
                            items: <String, Color>{
                              'Low': Colors.green,
                              'Medium': Colors.yellow,
                              'High': Colors.red
                            }.entries.map<DropdownMenuItem<String>>((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: entry.value,
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Add spacing between the dot and the text
                                    Text(entry
                                        .key), // Optional: Remove this line if you don't want text next to the dots
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      // Due Date Picker
                      ListTile(
                        title: const Text('Choose Due Date'),
                        subtitle: Text(
                          selectedDueDate != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(selectedDueDate!) // Format the date
                              : 'No date chosen',
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != selectedDueDate) {
                            setState(() {
                              selectedDueDate = picked;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      // Reminder Time Picker
                      ListTile(
                        title: const Text('Choose Reminder Time'),
                        subtitle: Text(selectedReminderTime != null
                            ? selectedReminderTime.toString()
                            : 'No reminder set'),
                        onTap: () async {
                          // Ask the user to pick a date first.
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedReminderTime ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            // After a date is picked, ask the user to pick a time.
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  selectedReminderTime ?? DateTime.now()),
                            );
                            if (pickedTime != null) {
                              // Combine the picked date and time into a single DateTime object.
                              setState(() {
                                selectedReminderTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      // Add Task Button
                      Container(
                        color: Colors.lightBlueAccent,
                        child: TextButton(
                          onPressed: () {
                            final String enteredText = typedText
                                .trim(); // Trim to remove leading/trailing whitespaces
                            if (enteredText.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Empty Field',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: const Text(
                                        'Please enter a task name.',
                                        textAlign: TextAlign.center),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK',
                                            textAlign: TextAlign.center),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Clear the text field and add the task
                              messageTextController.clear();
                              Provider.of<TaskData>(context, listen: false)
                                  .addTask(
                                enteredText,
                                dueDate: selectedDueDate,
                                priority: selectedPriority,
                                reminderTime: selectedReminderTime,
                              );
                              Navigator.pop(context); // Close the bottom sheet
                            }
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 43,
                right: 20,
                child: SpeechButton(
                  onSpeechResult:
                      updateTypedText, // callback function to update the text based on speech input
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
