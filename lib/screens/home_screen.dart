import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_details_screen.dart'; // Import the Todo Details screen
import '../main.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) => TodoNotifier());

class Todo {
  final String title;
  final String description;
  final DateTime creationDate;
  final DateTime? dueDate;
  final bool completed;
  final String category;

  Todo({
    required this.title,
    this.description = '',
    required this.creationDate,
    this.dueDate,
    this.completed = false,
    this.category = 'General',
  });
}

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void toggleComplete(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Todo(
            title: state[i].title,
            description: state[i].description,
            creationDate: state[i].creationDate,
            dueDate: state[i].dueDate,
            completed: !state[i].completed,
            category: state[i].category,
          )
        else
          state[i],
    ];
  }

  void updateTodoAt(int index, Todo updatedTodo) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedTodo else state[i],
    ];
  }

  void removeTodoAt(int index) {
    state = List.from(state)..removeAt(index);
  }
}

// Import the themeProvider from main.dart


// Filter provider for category filtering
final categoryFilterProvider = StateProvider<String>((ref) => 'All');

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered todos provider
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  
  return todos.where((todo) {
    // Apply category filter
    if (categoryFilter != 'All' && todo.category != categoryFilter) {
      return false;
    }
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      return todo.title.toLowerCase().contains(searchQuery) || 
             todo.description.toLowerCase().contains(searchQuery);
    }
    
    return true;
  }).toList();
});

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
    final filteredTodos = ref.watch(filteredTodosProvider);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final categoryFilter = ref.watch(categoryFilterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Welcome, ${username.split('@')[0]}',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              username.split('@')[0][0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 22,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              DateTime.now().toString().substring(0, 10),
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme(
                    themeMode == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                },
                tooltip: 'Toggle Theme',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search todos...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic, color: colorScheme.primary),
                    onPressed: () {
                      // Voice search functionality
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onChanged: (query) {
                  ref.read(searchQueryProvider.notifier).state = query;
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12, top: 8),
                    child: Text(
                      'Categories',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildFilterChip(ref, 'All'),
                        _buildFilterChip(ref, 'General'),
                        _buildFilterChip(ref, 'School'),
                        _buildFilterChip(ref, 'Personal'),
                        _buildFilterChip(ref, 'Urgent'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filteredTodos.isEmpty ? 'No tasks' : '${filteredTodos.length} Tasks',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Sort functionality
                    },
                    icon: Icon(Icons.sort, size: 18, color: colorScheme.primary),
                    label: Text(
                      'Sort',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final todo = filteredTodos[index];
                final bool isOverdue = todo.dueDate != null && 
                    todo.dueDate!.isBefore(DateTime.now()) && 
                    !todo.completed;
                
                return Dismissible(
                  key: Key(todo.creationDate.toString() + index.toString()),
                  background: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ref.read(todoProvider.notifier).removeTodoAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Todo deleted'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            // Undo delete functionality
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoDetailsScreen(
                              title: todo.title,
                              description: todo.description,
                              creationDate: todo.creationDate.toString(),
                              dueDate: todo.dueDate,
                              isCompleted: todo.completed,
                              category: todo.category,
                              todoIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox
                            Transform.scale(
                              scale: 1.2,
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: todo.completed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  onChanged: (value) {
                                    ref.read(todoProvider.notifier).toggleComplete(index);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          todo.title,
                                          style: textTheme.titleMedium?.copyWith(
                                            decoration: todo.completed
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: todo.completed
                                                ? Colors.grey
                                                : (isOverdue ? colorScheme.error : null),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (isOverdue)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: colorScheme.error.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: colorScheme.error, width: 1),
                                          ),
                                          child: Text(
                                            'OVERDUE',
                                            style: TextStyle(
                                              color: colorScheme.error,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (todo.description.isNotEmpty) ...[  
                                    const SizedBox(height: 8),
                                    Text(
                                      todo.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  // Tags and due date
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(todo.category).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _getCategoryColor(todo.category),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getCategoryIcon(todo.category),
                                              size: 14,
                                              color: _getCategoryColor(todo.category),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              todo.category,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _getCategoryColor(todo.category),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (todo.dueDate != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: isOverdue
                                                ? colorScheme.error.withOpacity(0.1)
                                                : colorScheme.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isOverdue
                                                  ? colorScheme.error
                                                  : colorScheme.primary,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                size: 14,
                                                color: isOverdue
                                                    ? colorScheme.error
                                                    : colorScheme.primary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatDate(todo.dueDate!),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isOverdue
                                                      ? colorScheme.error
                                                      : colorScheme.primary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredTodos.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context, ref);
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String label) {
    final selected = ref.watch(categoryFilterProvider) == label;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
        onSelected: (isSelected) {
          if (isSelected) {
            ref.read(categoryFilterProvider.notifier).state = label;
          }
        },
        selectedColor: _getCategoryColor(label),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'School':
        return Colors.blue;
      case 'Personal':
        return Colors.green;
      case 'Urgent':
        return Colors.red;
      case 'All':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'School':
        return Icons.school;
      case 'Personal':
        return Icons.person;
      case 'Urgent':
        return Icons.priority_high;
      case 'All':
        return Icons.category;
      default:
        return Icons.label;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    String title = '';
    String description = '';
    DateTime? dueDate;
    String category = 'General';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Todo'),
              content: SingleChildScrollView(
                child: Column(
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
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => description = value,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: category,
                      items: ['General', 'School', 'Personal', 'Urgent']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          category = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            dueDate != null
                                ? 'Due Date: ${_formatDate(dueDate!)}'
                                : 'No Due Date',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                dueDate = date;
                              });
                            }
                          },
                          child: Text('Select Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty) {
                      ref.read(todoProvider.notifier).addTodo(
                            Todo(
                              title: title,
                              description: description,
                              creationDate: DateTime.now(),
                              dueDate: dueDate,
                              category: category,
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('ADD'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
