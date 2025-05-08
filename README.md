# Flutter Todo App

<p align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/master/src/_assets/image/flutter-lockup.png" alt="Flutter" width="300"/>
</p>

## Overview

A modern, feature-rich Todo application built with Flutter and Riverpod for state management. This app provides a clean, intuitive interface for managing daily tasks with advanced features like categorization, due dates, and theme customization.

## Features

### User Authentication
- Email and password login system
- Form validation for secure access
- Personalized welcome screen with user avatar

### Todo Management
- Create, read, update, and delete todos
- Mark todos as complete/incomplete
- Set due dates for tasks
- Categorize todos (General, School, Personal, Urgent)
- View detailed information about each todo

### Search & Filtering
- Search todos by title or description
- Filter todos by category
- Quick access to all, completed, or active todos

### UI/UX Features
- Modern Material Design 3 implementation
- Custom color palette with purple primary, teal secondary, and coral accent colors
- Responsive design that works across different screen sizes
- Smooth animations and transitions
- Theme switching (Light mode, Dark mode, System default)

## Technology Stack

- **Framework**: Flutter (SDK ^3.7.2)
- **State Management**: Riverpod (flutter_riverpod: ^2.0.0)
- **Architecture**: Provider pattern with StateNotifier
- **UI Framework**: Material Design 3
- **Dependencies**:
  - flutter_riverpod: ^2.0.0
  - cupertino_icons: ^1.0.8

## Project Structure

```
lib/
├── main.dart            # Application entry point and theme configuration
├── screens/
│   ├── home_screen.dart         # Main todo list screen
│   ├── login_screen.dart        # User authentication screen
│   └── todo_details_screen.dart # Detailed view of a todo item
└── widgets/                     # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ishimwejeanluc/toDoappmobile.git
   cd todoapp
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage Guide

### Login
- Launch the app and enter your email and password
- The app validates your input before proceeding

### Home Screen
- View all your todos in a scrollable list
- Use the search bar to find specific todos
- Filter todos by category using the horizontal category list
- Add new todos with the floating action button
- Swipe left on a todo to delete it
- Tap on a todo to view its details

### Todo Details
- View comprehensive information about a todo
- Edit todo details including title, description, category, and due date
- Mark todo as complete/incomplete
- Delete the todo

### Theme Switching
- Toggle between light and dark modes using the theme button in the app bar

## Design Decisions

### Color Scheme
- Primary: Purple (#6750A4) - Represents creativity and productivity
- Secondary: Teal (#03DAC6) - Provides a refreshing contrast
- Tertiary: Coral (#EF5350) - Used for highlighting important elements

### Typography
- Clean, readable fonts with appropriate sizing for different screen elements
- Consistent text styling throughout the app

### UI Components
- Rounded corners on cards and buttons for a modern look
- Subtle shadows for depth and hierarchy
- Intuitive icons for better user understanding
- Responsive layouts that adapt to different screen sizes

## Future Enhancements

- Cloud synchronization for todos across devices
- Reminder notifications for upcoming due dates
- Subtasks within todos
- Sharing todos with other users
- Statistics and productivity insights
- Custom categories and color coding

## Screenshots

<p align="center">
  <img src="screenshots/login_screen.png" alt="Login Screen" width="250"/>
  <img src="screenshots/home_screen.png" alt="Home Screen" width="250"/>
  <img src="screenshots/todo_details.png" alt="Todo Details" width="250"/>
</p>

<p align="center">
  <img src="screenshots/dark_mode.png" alt="Dark Mode" width="250"/>
  <img src="screenshots/add_todo.png" alt="Add Todo" width="250"/>
  <img src="screenshots/category_filter.png" alt="Category Filter" width="250"/>
</p>



## Acknowledgements

- Flutter team for the amazing framework
- Riverpod for efficient state management
- Material Design for UI guidelines

