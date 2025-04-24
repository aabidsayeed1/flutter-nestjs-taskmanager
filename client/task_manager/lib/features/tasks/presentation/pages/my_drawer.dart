import 'package:flutter/material.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/core/generic/blocs/switch_bloc/switch_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              color: Colors.grey,
              child: Text('Task Drawer', style: Theme.of(context).textTheme.headlineMedium),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder:
                  (context, state) => GestureDetector(
                    onTap:
                        () =>
                            CustomNavigator.pushNamedAndRemoveAll(context, AppPages.PAGE_DASHBOARD),
                    child: ListTile(
                      leading: const Icon(Icons.folder_special),
                      title: const Text('My Tasks'),
                      trailing: Text(
                        '${state.pendingTasks.length} | ${state.completedTasks.length}',
                      ),
                    ),
                  ),
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder:
                  (context, state) => GestureDetector(
                    onTap:
                        () => CustomNavigator.pushNamedAndRemoveAll(
                          context,
                          AppPages.PAGE_RECYCLE_BIN,
                        ),
                    child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Bin'),
                      trailing: Text('${state.removedTasks.length}'),
                    ),
                  ),
            ),
            if (HelperUser.isLoggedIN())
              BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      // context.read<TasksBloc>().add(SyncOfflineTasks());
                      // context.read<TasksBloc>().add((BatchDeleteTasks()));
                      context.read<TasksBloc>().add(ClearAllTask());
                    },
                    child: ListTile(leading: const Icon(Icons.logout), title: const Text('Logout')),
                  );
                },
              ),
            if (!HelperUser.isLoggedIN())
              GestureDetector(
                onTap: () => CustomNavigator.pushTo(context, AppPages.PAGE_LOGIN),
                child: ListTile(leading: const Icon(Icons.login), title: const Text('Login')),
              ),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder:
                  (context, state) => Switch(
                    value: state.switchValue,
                    onChanged: (value) {
                      context.read<SwitchBloc>().add(
                        state.switchValue ? SwitchOffEvent() : SwitchOnEvent(),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
