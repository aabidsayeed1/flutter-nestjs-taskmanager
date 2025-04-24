import 'package:flutter/material.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';
import 'package:task_manager/services/guid_gen.dart';

class AddTaskPage extends StatelessWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Add Task', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
            controller: titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(label: Text('Title'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
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
                    AddTask(
                      task: TaskModel(
                        title: titleController.text,
                        description: descriptionController.text,
                        id: GUIDGen.generateUUID(),
                        date: DateTime.now().toString(),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  foregroundColor: Colors.white, // Text color
                  elevation: 3, // Shadow depth
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ), // Padding inside the button
                  textStyle: const TextStyle(
                    fontSize: 14, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  minimumSize: const Size(80, 40), // Minimum button size
                ),
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
