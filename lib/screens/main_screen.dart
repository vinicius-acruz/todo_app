import 'package:flutter/material.dart';
import 'package:todoey_flutter/screens/completed_task_screen.dart';
import 'package:todoey_flutter/screens/tasks_screen.dart';
// Import other screens you need
// import 'package:todoey_flutter/screens/home_screen.dart';
// import 'package:todoey_flutter/screens/completed_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Current index of the selected tab

  // List of widget options for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    // HomeScreen(), // Uncomment if you have a HomeScreen
    const TasksScreen(),
    CompletedTasksScreen(), // Uncomment if you have a CompletedTasksScreen
    // Add more screens as needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Uncomment and modify according to your screens
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home),
          //   label: 'Home',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks to do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed Tasks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Change as needed
        onTap: _onItemTapped,
      ),
    );
  }
}
