import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  late final List<Task> _tasks;

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void initTaskData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int x = prefs.getInt('length') ?? 0;
    List<Task> tasks = [];
    if (x > 0) {
      for (var i = 0; i < x; i++) {
        var json = prefs.getString('task${i + 1}') ?? '';
        if (json != '') {
          tasks.add(Task.fromJson(jsonDecode(json)));
        }
      }
    }
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(String newTaskTitle) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    String json = jsonEncode(task.toJson());
    prefs.setString('task${_tasks.length}', json);
    prefs.setInt('length', _tasks.length);
    notifyListeners();
  }

  void updateTask(Task task, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    task.toggleDone();
    String json = jsonEncode(task.toJson());
    prefs.setString('task${index + 1}', json);
    notifyListeners();
  }

  void deleteTask(Task task, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('task${index + 1}');
    _tasks.remove(task);
    prefs.setInt('length', _tasks.length);
    notifyListeners();
  }
}
