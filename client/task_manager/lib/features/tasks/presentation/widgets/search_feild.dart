import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_strings.dart';
import 'package:task_manager/features/tasks/data/types/task_type.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';

class SearchFeild extends StatelessWidget {
  final TextEditingController searchController;
  final TaskType type;
  const SearchFeild({super.key, required this.searchController, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search ${type.name} tasks',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              context.read<TasksBloc>().add(SearchTasks(searchController.text, type));
            },
          ),
        ),
        onChanged: (value) {
          EasyDebounce.debounce(
            AppStrings.STRING_DEBOUNCE_PRIMARY_BUTTON,
            Duration(milliseconds: 1000),
            () {
              context.read<TasksBloc>().add(SearchTasks(value, type));
            },
          );
        },
      ),
    );
  }
}
