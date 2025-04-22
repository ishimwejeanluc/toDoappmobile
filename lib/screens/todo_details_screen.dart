import 'package:flutter/material.dart';

class TodoDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String creationDate;

  TodoDetailsScreen({
    required this.title,
    required this.description,
    required this.creationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Description: $description', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Created on: $creationDate', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
