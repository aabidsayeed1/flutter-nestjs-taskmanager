import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/tasks/presentation/bloc/tasks_bloc/tasks_bloc.dart';
import 'package:task_manager/features/tasks/presentation/pages/add_task_page.dart';
import 'package:task_manager/features/tasks/presentation/pages/completed_tasks_screen.dart';
import 'package:task_manager/features/tasks/presentation/pages/favorite_tasks_screen.dart';
import 'package:task_manager/features/tasks/presentation/pages/my_drawer.dart';
import 'package:task_manager/features/tasks/presentation/pages/pending_tasks_screen.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  static const id = 'dashboardPage';

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': PendingTasksScreen(), 'title': 'Pending Tasks'},
    {'pageName': CompletedTasksScreen(), 'title': 'Completed Tasks'},
    {'pageName': FavoriteTasksScreen(), 'title': 'Favorite Tasks'},
  ];

  var _selectedPageIndex = 0;

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AddTaskPage(),
            ),
          ),
    );
  }

  @override
  void initState() {
    context.read<TasksBloc>().add(FetchAllTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageDetails[_selectedPageIndex]['title']),
        actions: [IconButton(onPressed: () => _addTask(context), icon: const Icon(Icons.add))],
      ),
      drawer: const MyDrawer(),
      body: _pageDetails[_selectedPageIndex]['pageName'],
      floatingActionButton:
          _selectedPageIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  _addTask(context);
                },
                tooltip: 'Add Task',
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          _selectedPageIndex = index;
          (context as Element).markNeedsBuild();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle_sharp),
            label: 'Pending Tasks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite Tasks'),
        ],
      ),
    );
  }
}
