import 'package:flutter/material.dart';
import 'todo_details_screen.dart'; // Import the Todo Details screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _todos = [];
  String _filter = 'All'; // Default filter

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';

        return AlertDialog(
          title: Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                ),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _todos.add({
                      'title': title,
                      'description': description,
                      'completed': false,
                      'creationDate': DateTime.now().toString(),
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> get filteredTodos {
    if (_filter == 'Completed') {
      return _todos.where((todo) => todo['completed']).toList();
    } else if (_filter == 'Pending') {
      return _todos.where((todo) => !todo['completed']).toList();
    }
    return _todos; // Return all todos
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<String>(
            value: _filter,
            icon: Icon(Icons.filter_list),
            onChanged: (String? newValue) {
              setState(() {
                _filter = newValue!;
              });
            },
            items:
                <String>[
                  'All',
                  'Completed',
                  'Pending',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User's avatar and welcome message
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Text(
                    email[0].toUpperCase(), // Display first letter of email
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Welcome, $email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            // List of todos
            Expanded(
              child: ListView.builder(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        todo['title'],
                        style:
                            todo['completed']
                                ? TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                                : null,
                      ),
                      trailing: Checkbox(
                        value: todo['completed'],
                        onChanged: (value) {
                          setState(() {
                            todo['completed'] = value!;
                          });
                        },
                      ),
                      onLongPress: () {
                        setState(() {
                          _todos.removeAt(index);
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TodoDetailsScreen(
                                  title: todo['title'],
                                  description: todo['description'],
                                  creationDate: todo['creationDate'],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}
