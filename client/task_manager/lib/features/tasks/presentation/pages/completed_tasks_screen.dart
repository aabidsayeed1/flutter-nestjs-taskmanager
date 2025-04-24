import 'package:flutter/material.dart';
import 'package:task_manager/features/tasks/data/types/task_type.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/features/tasks/presentation/widgets/search_feild.dart';

import 'package:task_manager/features/tasks/presentation/widgets/tasks_list.dart';

class CompletedTasksScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        final tasksList = state.completedTasks;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchFeild(searchController: _searchController, type: TaskType.completed),
            Center(child: Chip(label: Text('${tasksList.length} Tasks'))),
            TasksList(taskList: tasksList),
          ],
        );
      },
    );
  }
}
