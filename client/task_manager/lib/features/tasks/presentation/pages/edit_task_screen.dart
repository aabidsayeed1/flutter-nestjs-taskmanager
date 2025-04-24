import 'package:flutter/material.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskModel oldTask;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  EditTaskScreen({super.key, required this.oldTask});

  @override
  Widget build(BuildContext context) {
    titleController.text = oldTask.title;
    descriptionController.text = oldTask.description;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Edit Task', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
            controller: titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(label: Text('Title'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<TasksBloc>().add(
                    EditTask(
                      oldTask: oldTask,
                      newTask: TaskModel(
                        title: titleController.text,
                        description: descriptionController.text,
                        id: oldTask.id,
                        isDone: false,
                        isFavorite: oldTask.isFavorite,
                        date: DateTime.now().toString(),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, 
                  foregroundColor: Colors.white, 
                  elevation: 3, 
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ), 
                  textStyle: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), 
                  ),
                  minimumSize: const Size(80, 40),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
