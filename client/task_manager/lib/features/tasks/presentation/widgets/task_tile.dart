import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';
import 'package:task_manager/features/tasks/presentation/pages/edit_task_screen.dart';
import 'package:task_manager/features/tasks/presentation/widgets/popup_menu.dart';

import '../bloc/bloc_exports.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;
  void _removedOrDeletedTask(BuildContext context, TaskModel task) {
    context.read<TasksBloc>().add(
      task.isDeleted! ? DeleteTask(task: task) : RemoveTask(task: task),
    );
  }

  void _editTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditTaskScreen(oldTask: task),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap:
                      () =>
                          task.isDeleted!
                              ? null
                              : context.read<TasksBloc>().add(
                                MarkFavoriteOrUnfavoriteTask(task: task),
                              ),
                  child: Icon(task.isFavorite! ? Icons.star : Icons.star_outline),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        task.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: task.isDone! ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        DateFormat()
                            .add_yMMMd()
                            .add_Hms()
                            .format(DateTime.parse(task.date))
                            .toString(),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: task.isDone,
                onChanged:
                    task.isDeleted!
                        ? null
                        : (value) {
                          context.read<TasksBloc>().add(UpdateTask(task: task));
                        },
              ),
              PopupMenu(
                task: task,
                cancelOrDeleteCallback: () => _removedOrDeletedTask(context, task),
                likeOrDislikeCallback:
                    () => context.read<TasksBloc>().add(MarkFavoriteOrUnfavoriteTask(task: task)),
                editTaskCallback: () => _editTask(context),
                restoreCallback: () => context.read<TasksBloc>().add(RestoreTask(task: task)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/*ListTile(
        title: Text(
          task.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              decoration: task.isDone! ? TextDecoration.lineThrough : null),
        ),
        trailing: Checkbox(
          value: task.isDone,
          onChanged: task.isDeleted!
              ? null
              : (value) {
                  context.read<TasksBloc>().add(UpdateTask(task: task));
                },
        ),
        onLongPress: () => _removedOrDeletedTask(context, task)); */