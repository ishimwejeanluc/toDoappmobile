import 'package:flutter/material.dart';
import 'todo_details_screen.dart'; // Import the Todo Details screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _todos = [];
  String _filter = 'All'; // Default filter
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => title = value,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => description = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL'),
            ),
            ElevatedButton(
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
                  Navigator.pop(context);
                }
              },
              child: Text('ADD'),
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
    final username = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            backgroundColor: Colors.lightBlue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Welcome, $username',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.lightBlue.shade300,
                      Colors.lightBlue.shade600,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          username[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Pending'),
                      _buildFilterChip('Completed'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final todo = filteredTodos[index];
              return Dismissible(
                key: Key(todo['creationDate']),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white, size: 30),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text('Delete Todo'),
                        content: Text(
                          'Are you sure you want to delete this todo?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('CANCEL'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text('DELETE'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  setState(() {
                    _todos.removeWhere(
                      (item) => item['creationDate'] == todo['creationDate'],
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Todo deleted'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() {
                            _todos.add(todo);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _listController,
                      curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          todo['title'],
                          style: TextStyle(
                            fontSize: 18,
                            decoration:
                                todo['completed']
                                    ? TextDecoration.lineThrough
                                    : null,
                            color:
                                todo['completed']
                                    ? Colors.grey
                                    : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          todo['description'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: todo['completed'],
                            activeColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                todo['completed'] = value;
                              });
                            },
                          ),
                        ),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TodoDetailsScreen(
                                      title: todo['title'],
                                      description: todo['description'] ?? '',
                                      creationDate: todo['creationDate'],
                                      isCompleted: todo['completed'],
                                    ),
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: filteredTodos.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        backgroundColor: Colors.lightBlue,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Todo', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filter == label;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: Colors.lightBlue,
      backgroundColor: Colors.grey[200],
      onSelected: (selected) {
        setState(() {
          _filter = label;
        });
      },
    );
  }
}
