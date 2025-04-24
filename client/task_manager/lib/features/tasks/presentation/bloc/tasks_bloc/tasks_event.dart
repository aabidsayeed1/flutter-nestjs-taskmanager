part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class AddTask extends TasksEvent {
  final TaskModel task;

  const AddTask({required this.task});
  @override
  List<Object> get props => [task];
}

class UpdateTask extends TasksEvent {
  final TaskModel task;

  const UpdateTask({required this.task});
  @override
  List<Object> get props => [task];
}

class RemoveTask extends TasksEvent {
  final TaskModel task;

  const RemoveTask({required this.task});
  @override
  List<Object> get props => [task];
}

class DeleteTask extends TasksEvent {
  final TaskModel task;

  const DeleteTask({required this.task});
  @override
  List<Object> get props => [task];
}

class MarkFavoriteOrUnfavoriteTask extends TasksEvent {
  final TaskModel task;

  const MarkFavoriteOrUnfavoriteTask({required this.task});
  @override
  List<Object> get props => [task];
}

class EditTask extends TasksEvent {
  final TaskModel oldTask;
  final TaskModel newTask;

  const EditTask({required this.oldTask, required this.newTask});
  @override
  List<Object> get props => [oldTask, newTask];
}

class RestoreTask extends TasksEvent {
  final TaskModel task;

  const RestoreTask({required this.task});
  @override
  List<Object> get props => [task];
}

class DeleteAllTasks extends TasksEvent {
  const DeleteAllTasks();
  @override
  List<Object> get props => [];
}

class SyncOfflineTasks extends TasksEvent {
  const SyncOfflineTasks();
  @override
  List<Object> get props => [];
}

class BatchDeleteTasks extends TasksEvent {
  const BatchDeleteTasks();
  @override
  List<Object> get props => [];
}

class FetchAllTasks extends TasksEvent {
  const FetchAllTasks();
  @override
  List<Object> get props => [];
}

class ClearAllTask extends TasksEvent {
  const ClearAllTask();
  @override
  List<Object> get props => [];
}

class SearchTasks extends TasksEvent {
  final String query;
  final TaskType type;
  const SearchTasks(this.query, this.type);
  @override
  List<Object> get props => [query,type];
}
