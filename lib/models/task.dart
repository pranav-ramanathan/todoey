class Task {
  final String name;
  bool isDone;

  Task({required this.name, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toJson() {
    return {'taskName': name, 'isDone': isDone};
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['taskName'], 
      isDone: json['isDone']
    );
  }
}
