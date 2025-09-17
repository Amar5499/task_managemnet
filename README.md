# Task Manager

A simple and minimal **Flutter task management app** with smooth animations and pastel-themed UI. Manage your tasks with add, edit, delete, filter, and sort features. The app uses **Provider** for state management and **SharedPreferences** for local storage.

## Features

- Add, edit, and delete tasks
- Mark tasks as completed
- Filter tasks by status (All / Completed / Pending)
- Sort tasks by due date (ascending / descending)
- Smooth animations in task list
- Pastel color theme
- Persistent storage using SharedPreferences
- Clean and minimal UI design

## Getting Started

### Prerequisites

- Flutter SDK >= 3.7.2
- Android Studio / VS Code / Xcode
- Git

### Installation

1. Clone the repository:
git clone https://github.com/Amar5499/task_managemnet.git
cd task_managemnet
2. Install dependencies:

flutter pub get
3. Run the app:

flutter run

For iOS, configure signing in Xcode before running.

Usage

Open the app to view your task list

Tap Add Task to create a new task

Tap a task to edit it

Use AppBar icons to filter and sort tasks

Mark tasks completed or delete via task tile buttons

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
