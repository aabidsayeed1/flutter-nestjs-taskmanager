import 'package:flutter/material.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';
import 'package:task_manager/services/guid_gen.dart';
import 'package:task_manager/features/tasks/presentation/widgets/task_tile.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.taskList});

  final List<TaskModel> taskList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          children:
              taskList
                  .map(
                    (task) => ExpansionPanelRadio(
                      value: task.id + GUIDGen.generateUUID(),
                      headerBuilder: (context, isOpen) => TaskTile(task: task),
                      body: ListTile(
                        title: SelectableText.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Text\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: task.title),
                              const TextSpan(
                                text: '\n\nDescription\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: task.description),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

/*Expanded(
      child: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            final task = taskList[index];
            return TaskTile(task: task);
          }),
    ); */
