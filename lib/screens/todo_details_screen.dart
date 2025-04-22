import 'package:flutter/material.dart';

class TodoDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String creationDate;
  final bool isCompleted;

  TodoDetailsScreen({
    required this.title,
    required this.description,
    required this.creationDate,
    this.isCompleted = false,
  });

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.lightBlue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
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
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 80,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            context,
                            'Status',
                            isCompleted ? 'Completed' : 'Pending',
                            icon:
                                isCompleted
                                    ? Icons.check_circle
                                    : Icons.pending,
                            iconColor:
                                isCompleted ? Colors.green : Colors.orange,
                          ),
                          Divider(height: 32),
                          _buildSection(
                            context,
                            'Description',
                            description.isEmpty
                                ? 'No description provided'
                                : description,
                            icon: Icons.description,
                          ),
                          Divider(height: 32),
                          _buildSection(
                            context,
                            'Created on',
                            _formatDate(creationDate),
                            icon: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Implement edit functionality
                            _showEditDialog(context);
                          },
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text(
                            'Edit Todo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
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

  Widget _buildSection(
    BuildContext context,
    String title,
    String content, {
    IconData? icon,
    Color iconColor = Colors.lightBlue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTitle = title;
        String newDescription = description;

        return AlertDialog(
          title: Text('Edit Todo'),
          content: Column(
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality
                Navigator.pop(context);
              },
              child: Text('SAVE'),
            ),
          ],
        );
      },
    );
  }
}
