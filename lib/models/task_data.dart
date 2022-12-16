import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  late final List<Task> _tasks;

  UnmodifiableListView<Task> get tasks {
    // prevents users modifying tasks outside class
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  Future initTaskData() async {
    List<Task> tasks = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // checks for saved tasks
    List<String> savedTasks = prefs.getStringList('tasksNamesList') ?? [];
    if (savedTasks.isNotEmpty) {
      for (var item in savedTasks) {
        var json = prefs.getString(item) ?? '';
        if (json != '') {
          // Shared preferences only accept strings
          tasks.add(
            Task.fromJson(
              jsonDecode(json),
            ),
          );
        }
      }
    }
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(String newTaskTitle) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedTasks = prefs.getStringList('tasksNamesList') ?? [];
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    String json = jsonEncode(task.toJson());
    prefs.setString(task.name, json);
    savedTasks.add(task.name);
    prefs.setStringList('tasksNamesList', savedTasks);
    notifyListeners();
  }

  void updateTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    task.toggleDone();
    String json = jsonEncode(task.toJson());
    prefs.setString(task.name, json);
    notifyListeners();
  }

  void deleteTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasksNamesList');
    prefs.remove(task.name);
    savedTasks?.remove(task.name);
    _tasks.remove(task);
    notifyListeners();
  }
}
