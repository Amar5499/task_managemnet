Task Manager

A simple and minimal Flutter task management app with support for adding, editing, deleting, filtering, and sorting tasks. The app uses Provider for state management and SharedPreferences for local storage.

The UI features pastel colors, smooth animations, and a clean, modern design.

Features

Add, edit, and delete tasks

Mark tasks as completed

Filter tasks by status (All / Completed / Pending)

Sort tasks by due date (ascending / descending)

Smooth animations for task list

Pastel color theme for a pleasing UI

Persistent storage using SharedPreferences

Minimal and responsive design


Getting Started
Prerequisites

Flutter SDK >= 3.7.2

Android Studio / VS Code / Xcode (for iOS)

Git

Installation

Clone the repository:

git clone https://github.com/Amar5499/task_managemnet.git
cd task_managemnet


Install dependencies:

flutter pub get


Run the app:

flutter run


For iOS, you may need to open the .xcworkspace in Xcode and configure signing.

Usage

Open the app to see the task list.

Tap Add Task to create a new task.

Tap an existing task to edit.

Use the filter and sort buttons in the AppBar to organize tasks.

Mark tasks as completed or delete them with the buttons on each task tile.

Dependencies

Flutter

Provider

SharedPreferences

Cupertino Icons

Project Structure
lib/
├─ application/       # Providers / state management
├─ data/              # Repositories
├─ domain/            # Entities
├─ presentation/      # UI screens and widgets
└─ main.dart

Notes

The app uses SharedPreferences to store tasks locally.

Animations are implemented in task list using FadeTransition and SlideTransition.

Pastel color scheme for a soft, modern look.

Filtering and sorting options are available in the AppBar.


Author

Amarbabu T
GitHub: Amar5499
