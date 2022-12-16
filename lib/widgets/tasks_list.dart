import 'package:flutter/material.dart';
import 'package:todoey/screens/delete_task_screen.dart';
import 'package:todoey/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import '../models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              isChecked: task.isDone,
              taskTitle: task.name,
              checkBoxCallback: (checkBoxState) {
                taskData.updateTask(task);
              },
              longPressCallBack: () {
                // taskData.deleteTask(task);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: DeleteTaskScreen(
                        task: task,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
