import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart'; // Import to access the Todo class and todoProvider
import '../main.dart'; // Import to access the themeProvider

class TodoDetailsScreen extends ConsumerWidget {
  final String title;
  final String description;
  final String creationDate;
  final DateTime? dueDate;
  final bool isCompleted;
  final String category;
  final int? todoIndex;

  const TodoDetailsScreen({
    required this.title,
    required this.description,
    required this.creationDate,
    this.dueDate,
    this.isCompleted = false,
    this.category = 'General',
    this.todoIndex,
  });

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  bool _isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    return dueDate.isBefore(DateTime.now()) && !isCompleted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (todoIndex != null) {
                    ref.read(todoProvider.notifier).toggleComplete(todoIndex!);
                    Navigator.pop(context);
                  }
                },
                tooltip: isCompleted ? 'Mark as incomplete' : 'Mark as complete',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                    top: 80,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getCategoryIcon(category),
                              color: colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            category,
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(isCompleted, dueDate),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(isCompleted, dueDate),
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(isCompleted, dueDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description section
                  _buildDetailCard(
                    context,
                    title: 'Description',
                    content: description.isEmpty ? 'No description provided' : description,
                    icon: Icons.description_outlined,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  
                  // Dates section
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dates',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateItem(
                                context,
                                title: 'Created',
                                date: _formatDate(creationDate),
                                icon: Icons.calendar_today_outlined,
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                              ),
                            ),
                            if (dueDate != null) ...[  
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDateItem(
                                  context,
                                  title: 'Due Date',
                                  date: _formatDateTime(dueDate!),
                                  icon: Icons.event_outlined,
                                  isOverdue: _isOverdue(dueDate),
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showEditDialog(context, ref);
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Todo'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (todoIndex != null) {
                            ref.read(todoProvider.notifier).removeTodoAt(todoIndex!);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          minimumSize: const Size(56, 56),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailCard(BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateItem(BuildContext context, {
    required String title,
    required String date,
    required IconData icon,
    bool isOverdue = false,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final color = isOverdue ? colorScheme.error : colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
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
  
  Color _getStatusColor(bool isCompleted, DateTime? dueDate) {
    if (isCompleted) {
      return Colors.green;
    } else if (_isOverdue(dueDate)) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
  
  IconData _getStatusIcon(bool isCompleted, DateTime? dueDate) {
    if (isCompleted) {
      return Icons.check_circle;
    } else if (_isOverdue(dueDate)) {
      return Icons.warning;
    } else {
      return Icons.pending;
    }
  }
  
  String _getStatusText(bool isCompleted, DateTime? dueDate) {
    if (isCompleted) {
      return 'COMPLETED';
    } else if (_isOverdue(dueDate)) {
      return 'OVERDUE';
    } else {
      return 'PENDING';
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    if (todoIndex == null) return;
    
    String newTitle = title;
    String newDescription = description;
    DateTime? newDueDate = dueDate;
    String newCategory = category;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Todo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: TextEditingController(text: title),
                      onChanged: (value) => newTitle = value,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: TextEditingController(text: description),
                      onChanged: (value) => newDescription = value,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: newCategory,
                      items: ['General', 'School', 'Personal', 'Urgent']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          newCategory = value!;
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
                            newDueDate != null
                                ? 'Due Date: ${_formatDateTime(newDueDate!)}'
                                : 'No Due Date',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: newDueDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                newDueDate = date;
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
                    // Update the todo using the provider
                    final todoNotifier = ref.read(todoProvider.notifier);
                    final todos = ref.read(todoProvider);
                    
                    if (todoIndex! < todos.length) {
                      final updatedTodo = Todo(
                        title: newTitle,
                        description: newDescription,
                        creationDate: DateTime.parse(creationDate),
                        dueDate: newDueDate,
                        completed: isCompleted,
                        category: newCategory,
                      );
                      
                      // Update the todo at the specified index
                      todoNotifier.updateTodoAt(todoIndex!, updatedTodo);
                      Navigator.pop(context);
                      Navigator.pop(context); // Go back to the home screen
                    }
                  },
                  child: Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
