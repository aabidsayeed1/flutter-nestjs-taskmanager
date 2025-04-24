import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/generic/validity_check.dart';
import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'package:task_manager/features/tasks/data/datasources/create_batch_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/create_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/delete_batch_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/delete_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/get_tasks_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/search_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/update_task_data_source.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';
import 'package:task_manager/features/tasks/data/types/task_type.dart';

import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  bool internetStatus = true;
  ValidityCheck validityCheck;
  CreateTaskDataSource createTaskDataSource;
  GetTaskDataSource getTaskDataSource;
  UpdateTaskDataSource updateTaskDataSource;
  DeleteTaskDataSource deleteTaskDataSource;
  CreateBatchTaskDataSource createBatchTaskDataSource;
  DeleteBatchTaskDataSource deleteBatchTaskDataSource;
  SearchTaskDataSource searchTaskDataSource;
  TasksBloc(
    this.validityCheck,
    this.createTaskDataSource,
    this.getTaskDataSource,
    this.updateTaskDataSource,
    this.deleteTaskDataSource,
    this.createBatchTaskDataSource,
    this.deleteBatchTaskDataSource,
    this.searchTaskDataSource,
  ) : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTasks);
    on<SyncOfflineTasks>(_onSyncOfflineTasks);
    on<BatchDeleteTasks>(_onBatchDeleteTasks);
    on<FetchAllTasks>(_onFetchAllTasks);
    on<ClearAllTask>(_onClearAllTask);
    on<SearchTasks>(_onSearchTasks);

    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        internetStatus = true;
        HelperUI.showToast(msg: "You're back online!", type: ToastType.success);
        add(SyncOfflineTasks());
        add(BatchDeleteTasks());
        add(FetchAllTasks());
      } else {
        internetStatus = false;
        HelperUI.showToast(msg: "Oops! You're offline", type: ToastType.information);
      }
    });
    if (_isStateEmpty(state) && HelperUser.isLoggedIN()) {
      add(FetchAllTasks());
    }
  }
  void _onSearchTasks(SearchTasks event, Emitter<TasksState> emit) async {
    if (internetStatus) {
      final result = await validityCheck.checkAndProceedToDataSource(
        searchTaskDataSource,
        data: {'query': event.query, 'type': event.type.name},
      );

      result.fold(
        (failure) {
          HelperUI.showToast(msg: 'Failed to search tasks', type: ToastType.error);
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            final List<TaskModel> searchResults = r;
            emit(
              TasksState(
                pendingTasks: event.type == TaskType.pending ? searchResults : state.pendingTasks,
                completedTasks:
                    event.type == TaskType.completed ? searchResults : state.completedTasks,
                favoriteTasks:
                    event.type == TaskType.favorite ? searchResults : state.favoriteTasks,
                removedTasks: event.type == TaskType.removed ? searchResults : state.removedTasks,
              ),
            );
          });
        },
      );
    } else {
      // If offline, filter tasks locally
      // List<TaskModel> filteredTasks;
      // switch (event.type) {
      //   case TaskType.pending:
      //     filteredTasks = state.pendingTasks.where((task) {
      //       final title = task.title.toLowerCase();
      //       final description = task.description.toLowerCase();
      //       return title.contains(event.query.toLowerCase()) || description.contains(event.query.toLowerCase());
      //     }).toList();
      //     break;
      //   case TaskType.completed:
      //     filteredTasks = state.completedTasks.where((task) {
      //       final title = task.title.toLowerCase() ;
      //       final description = task.description.toLowerCase();
      //       return title.contains(event.query.toLowerCase()) || description.contains(event.query.toLowerCase());
      //     }).toList();
      //     break;
      //   default:
      //     filteredTasks = [];
      // }

      // emit(
      //   TasksState(
      //     pendingTasks: event.type == 'pending' ? filteredTasks : currentState.pendingTasks,
      //     completedTasks: event.type == 'completed' ? filteredTasks : currentState.completedTasks,
      //     favoriteTasks: event.type == 'favorite' ? filteredTasks : currentState.favoriteTasks,
      //     removedTasks: event.type == 'removed' ? filteredTasks : currentState.removedTasks,
      //   ),
      // );
    }
  }

  bool _isStateEmpty(TasksState state) {
    return state.pendingTasks.isEmpty &&
        state.completedTasks.isEmpty &&
        state.favoriteTasks.isEmpty &&
        state.removedTasks.isEmpty;
  }

  void _onFetchAllTasks(FetchAllTasks event, Emitter<TasksState> emit) async {
    final result = await validityCheck.checkAndProceedToDataSource(getTaskDataSource);

    result.fold(
      (failure) {
        HelperUI.showToast(msg: 'Failed to fetch tasks', type: ToastType.error);
      },
      (loaded) {
        loaded.fold((f) {}, (r) async {
          final List<TaskModel> fetchedTasks = r;
          final List<TaskModel> offlineTasks = [
            ...state.pendingTasks.where((task) => task.isOffline == true),
            ...state.completedTasks.where((task) => task.isOffline == true),
            ...state.favoriteTasks.where((task) => task.isOffline == true),
            ...state.removedTasks.where((task) => task.isOffline == true),
          ];

          final Map<String, TaskModel> mergedTasksMap = {};

          for (final task in fetchedTasks) {
            mergedTasksMap[task.id] = task;
          }

          for (final task in offlineTasks) {
            mergedTasksMap[task.id] = task;
          }

          final List<TaskModel> mergedTasks = mergedTasksMap.values.toList();

          final List<TaskModel> pendingTasks =
              mergedTasks.where((task) => !task.isDone! && !task.isDeleted!).toList();
          final List<TaskModel> completedTasks =
              mergedTasks.where((task) => task.isDone! && !task.isDeleted!).toList();
          final List<TaskModel> favoriteTasks =
              mergedTasks.where((task) => task.isFavorite! && !task.isDeleted!).toList();
          final List<TaskModel> removedTasks =
              mergedTasks.where((task) => task.isDeleted!).toList();

          emit(
            TasksState(
              pendingTasks: pendingTasks,
              completedTasks: completedTasks,
              favoriteTasks: favoriteTasks,
              removedTasks: removedTasks,
              offlineDeleteTasks: state.offlineDeleteTasks,
            ),
          );
        });
      },
    );
  }

  void _onSyncOfflineTasks(SyncOfflineTasks event, Emitter<TasksState> emit) async {
    final state = this.state;

    final List<TaskModel> offlineTasks = [
      ...state.pendingTasks.where((task) => task.isOffline == true),
      ...state.completedTasks.where((task) => task.isOffline == true),
      ...state.favoriteTasks.where((task) => task.isOffline == true),
      ...state.removedTasks.where((task) => task.isOffline == true),
    ];

    final uniqueOfflineTasks = {for (final task in offlineTasks) task.id: task}.values.toList();

    if (uniqueOfflineTasks.isNotEmpty) {
      final requestData =
          uniqueOfflineTasks.map((task) {
            return task.copyWith(isOffline: false).toJson();
          }).toList();

      final result = await validityCheck.checkAndProceedToDataSource(
        createBatchTaskDataSource,
        data: requestData,
      );

      result.fold(
        (failure) {
          HelperUI.showToast(msg: 'Failed to sync tasks', type: ToastType.information);
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            final List<TaskModel> updatedTasks = r as List<TaskModel>;
            emit(
              TasksState(
                pendingTasks:
                    state.pendingTasks.map((task) {
                      final updatedTask = updatedTasks.firstWhere(
                        (updated) => updated.id == task.id,
                        orElse: () => task,
                      );
                      return updatedTask.copyWith(isOffline: false);
                    }).toList(),
                completedTasks:
                    state.completedTasks.map((task) {
                      final updatedTask = updatedTasks.firstWhere(
                        (updated) => updated.id == task.id,
                        orElse: () => task,
                      );
                      return updatedTask.copyWith(isOffline: false);
                    }).toList(),
                favoriteTasks:
                    state.favoriteTasks.map((task) {
                      final updatedTask = updatedTasks.firstWhere(
                        (updated) => updated.id == task.id,
                        orElse: () => task,
                      );
                      return updatedTask.copyWith(isOffline: false);
                    }).toList(),
                removedTasks:
                    state.removedTasks.map((task) {
                      final updatedTask = updatedTasks.firstWhere(
                        (updated) => updated.id == task.id,
                        orElse: () => task,
                      );
                      return updatedTask.copyWith(isOffline: false);
                    }).toList(),
                offlineDeleteTasks: state.offlineDeleteTasks,
              ),
            );
          });
        },
      );
    }
  }

  void _onBatchDeleteTasks(BatchDeleteTasks event, Emitter<TasksState> emit) async {
    final offlineDeleteTasks = state.offlineDeleteTasks;
    if (internetStatus && offlineDeleteTasks.isNotEmpty) {
      final result = await validityCheck.checkAndProceedToDataSource(
        deleteBatchTaskDataSource,
        data: offlineDeleteTasks,
      );
      result.fold((failure) {}, (loaded) {
        loaded.fold((f) {}, (r) async {
          emit(
            TasksState(
              removedTasks: state.removedTasks,
              pendingTasks: state.pendingTasks,
              completedTasks: state.completedTasks,
              favoriteTasks: state.favoriteTasks,
              offlineDeleteTasks: List.from(state.offlineDeleteTasks)..clear(),
            ),
          );
        });
      });
    }
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    if (internetStatus) {
      final result = await validityCheck.checkAndProceedToDataSource(
        createTaskDataSource,
        data: event.task.copyWith(isOffline: false).toJson(),
      );
      result.fold(
        (failure) {
          emit(
            TasksState(
              pendingTasks: List.from(state.pendingTasks)
                ..insert(0, event.task.copyWith(isOffline: true)),
              completedTasks: state.completedTasks,
              favoriteTasks: state.favoriteTasks,
              removedTasks: state.removedTasks,
              offlineDeleteTasks: state.offlineDeleteTasks,
            ),
          );
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            r as TaskModel;
            emit(
              TasksState(
                pendingTasks: List.from(state.pendingTasks)
                  ..insert(0, event.task.copyWith(isOffline: false)),
                completedTasks: state.completedTasks,
                favoriteTasks: state.favoriteTasks,
                removedTasks: state.removedTasks,
                offlineDeleteTasks: state.offlineDeleteTasks,
              ),
            );
          });
        },
      );
    } else {
      emit(
        TasksState(
          pendingTasks: List.from(state.pendingTasks)
            ..insert(0, event.task.copyWith(isOffline: true)),
          completedTasks: state.completedTasks,
          favoriteTasks: state.favoriteTasks,
          removedTasks: state.removedTasks,
          offlineDeleteTasks: state.offlineDeleteTasks,
        ),
      );
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    TaskModel task = event.task;
    if (internetStatus && task.isOffline == false) {
      final result = await validityCheck.checkAndProceedToDataSource(
        updateTaskDataSource,
        data: task.copyWith(isOffline: false, isDone: task.isDone! ? false : true),
      );
      result.fold(
        (failure) {
          task = event.task.copyWith(isOffline: true);
          _updateTask(task, emit);
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            task = event.task.copyWith(isOffline: false);
            _updateTask(task, emit);
          });
        },
      );
    } else {
      task = event.task.copyWith(isOffline: true);
      _updateTask(task, emit);
    }
  }

  _updateTask(TaskModel task, Emitter<TasksState> emit) {
    final state = this.state;
    List<TaskModel> pendingTasks = state.pendingTasks;
    List<TaskModel> completedTasks = state.completedTasks;
    List<TaskModel> favoriteTasks = state.favoriteTasks;
    if (task.isDone == false) {
      if (task.isFavorite == false) {
        pendingTasks = List.from(pendingTasks)..remove(task);
        completedTasks = List.from(completedTasks)..insert(0, task.copyWith(isDone: true));
      } else {
        var taskIndex = favoriteTasks.indexOf(task);
        pendingTasks = List.from(pendingTasks)..remove(task);
        completedTasks = List.from(completedTasks)..insert(0, task.copyWith(isDone: true));
        favoriteTasks =
            List.from(favoriteTasks)
              ..remove(task)
              ..insert(taskIndex, task.copyWith(isDone: true));
      }
    } else {
      if (task.isFavorite == false) {
        completedTasks = List.from(completedTasks)..remove(task);
        pendingTasks = List.from(pendingTasks)..insert(0, task.copyWith(isDone: false));
      } else {
        var taskIndex = favoriteTasks.indexOf(task);
        completedTasks = List.from(completedTasks)..remove(task);
        pendingTasks = List.from(pendingTasks)..insert(0, task.copyWith(isDone: false));
        favoriteTasks =
            List.from(favoriteTasks)
              ..remove(task)
              ..insert(taskIndex, task.copyWith(isDone: false));
      }
    }
    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
        offlineDeleteTasks: state.offlineDeleteTasks,
      ),
    );
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    TaskModel task = event.task;
    if (internetStatus && task.isOffline == false) {
      final result = await validityCheck.checkAndProceedToDataSource(
        updateTaskDataSource,
        data: task.copyWith(isOffline: false, isDeleted: true),
      );
      result.fold(
        (failure) {
          task = event.task.copyWith(isOffline: true);
          emit(
            TasksState(
              pendingTasks: List.from(state.pendingTasks)..remove(event.task),
              completedTasks: List.from(state.completedTasks)..remove(event.task),
              favoriteTasks: List.from(state.favoriteTasks)..remove(event.task),
              removedTasks: List.from(state.removedTasks)..add(task.copyWith(isDeleted: true)),
              offlineDeleteTasks: state.offlineDeleteTasks,
            ),
          );
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            task = event.task.copyWith(isOffline: false);
            emit(
              TasksState(
                pendingTasks: List.from(state.pendingTasks)..remove(event.task),
                completedTasks: List.from(state.completedTasks)..remove(event.task),
                favoriteTasks: List.from(state.favoriteTasks)..remove(event.task),
                removedTasks: List.from(state.removedTasks)..add(task.copyWith(isDeleted: true)),
                offlineDeleteTasks: state.offlineDeleteTasks,
              ),
            );
          });
        },
      );
    } else {
      task = event.task.copyWith(isOffline: true);
      emit(
        TasksState(
          pendingTasks: List.from(state.pendingTasks)..remove(event.task),
          completedTasks: List.from(state.completedTasks)..remove(event.task),
          favoriteTasks: List.from(state.favoriteTasks)..remove(event.task),
          removedTasks: List.from(state.removedTasks)..add(task.copyWith(isDeleted: true)),
          offlineDeleteTasks: state.offlineDeleteTasks,
        ),
      );
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    TaskModel task = event.task;
    final offlineDeleteTasks = task.isOffline == false ? [task.id] : [];
    if (internetStatus && task.isOffline == false) {
      final result = await validityCheck.checkAndProceedToDataSource(
        deleteTaskDataSource,
        data: task.id,
      );
      result.fold(
        (failure) {
          emit(
            TasksState(
              pendingTasks: state.pendingTasks,
              completedTasks: state.completedTasks,
              favoriteTasks: state.favoriteTasks,
              removedTasks: List.from(state.removedTasks)..remove(event.task),
              offlineDeleteTasks: List.from(
                <String>{...state.offlineDeleteTasks, ...offlineDeleteTasks}.toSet().toList(),
              ),
            ),
          );
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            emit(
              TasksState(
                pendingTasks: state.pendingTasks,
                completedTasks: state.completedTasks,
                favoriteTasks: state.favoriteTasks,
                removedTasks: List.from(state.removedTasks)..remove(event.task),
                offlineDeleteTasks: state.offlineDeleteTasks,
              ),
            );
          });
        },
      );
    } else {
      emit(
        TasksState(
          pendingTasks: state.pendingTasks,
          completedTasks: state.completedTasks,
          favoriteTasks: state.favoriteTasks,
          removedTasks: List.from(state.removedTasks)..remove(event.task),
          offlineDeleteTasks: List.from(
            <String>{...state.offlineDeleteTasks, ...offlineDeleteTasks}.toSet().toList(),
          ),
        ),
      );
    }
  }

  void _onMarkFavoriteOrUnfavoriteTask(
    MarkFavoriteOrUnfavoriteTask event,
    Emitter<TasksState> emit,
  ) async {
    TaskModel task = event.task;
    if (internetStatus && task.isOffline == false) {
      final result = await validityCheck.checkAndProceedToDataSource(
        updateTaskDataSource,
        data: task.copyWith(isFavorite: task.isFavorite! ? false : true),
      );
      result.fold(
        (failure) {
          task = event.task.copyWith(isOffline: true);
          updateFav(task, emit);
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            task = event.task.copyWith(isOffline: false);
            updateFav(task.copyWith(isOffline: false), emit);
          });
        },
      );
    } else {
      task = event.task.copyWith(isOffline: true);
      updateFav(task, emit);
    }
  }

  updateFav(TaskModel task, Emitter<TasksState> emit) {
    final state = this.state;
    List<TaskModel> pendingTasks = state.pendingTasks;
    List<TaskModel> completedTasks = state.completedTasks;
    List<TaskModel> favoriteTasks = state.favoriteTasks;
    if (task.isDone == false) {
      if (task.isFavorite == false) {
        int taskIndex = pendingTasks.indexOf(task);
        pendingTasks =
            List.from(pendingTasks)
              ..remove(task)
              ..insert(taskIndex, task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, task.copyWith(isFavorite: true));
      } else {
        int taskIndex = pendingTasks.indexOf(task);
        pendingTasks =
            List.from(pendingTasks)
              ..remove(task)
              ..insert(taskIndex, task.copyWith(isFavorite: false));
        favoriteTasks.remove(task);
      }
    } else {
      if (task.isFavorite == false) {
        int taskIndex = completedTasks.indexOf(task);
        completedTasks =
            List.from(completedTasks)
              ..remove(task)
              ..insert(taskIndex, task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, task.copyWith(isFavorite: true));
      } else {
        int taskIndex = completedTasks.indexOf(task);
        completedTasks =
            List.from(completedTasks)
              ..remove(task)
              ..insert(taskIndex, task.copyWith(isFavorite: false));
        favoriteTasks.remove(task);
      }
    }
    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
        offlineDeleteTasks: state.offlineDeleteTasks,
      ),
    );
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    TaskModel oldTask = event.oldTask;
    TaskModel newTask = event.newTask;
    if (internetStatus && oldTask.isOffline == false) {
      final result = await validityCheck.checkAndProceedToDataSource(
        updateTaskDataSource,
        data: newTask.copyWith(isOffline: false),
      );
      result.fold(
        (failure) {
          newTask = event.newTask.copyWith(isOffline: true);
          updateEditTask(oldTask, newTask, emit);
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            newTask = event.newTask.copyWith(isOffline: false);
            updateEditTask(oldTask, newTask, emit);
          });
        },
      );
    } else {
      newTask = event.newTask.copyWith(isOffline: true);
      updateEditTask(oldTask, newTask, emit);
    }
  }

  void updateEditTask(TaskModel oldTask, TaskModel newTask, Emitter<TasksState> emit) {
    final state = this.state;
    List<TaskModel> favoriteTask = state.favoriteTasks;
    if (oldTask.isFavorite == true) {
      favoriteTask
        ..remove(oldTask)
        ..insert(0, newTask);
    }
    emit(
      TasksState(
        pendingTasks:
            List.from(state.pendingTasks)
              ..remove(oldTask)
              ..insert(0, newTask),
        completedTasks: state.completedTasks..remove(oldTask),
        favoriteTasks: favoriteTask,
        removedTasks: state.removedTasks,
        offlineDeleteTasks: state.offlineDeleteTasks,
      ),
    );
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    TaskModel task = event.task;
    if (internetStatus && task.isOffline == false) {
      final result = await validityCheck.checkAndProceedToDataSource(
        updateTaskDataSource,
        data: task.copyWith(isDeleted: false, isDone: false, isFavorite: false),
      );
      result.fold(
        (failure) {
          task = event.task.copyWith(isOffline: true);
          emit(
            TasksState(
              pendingTasks: List.from(
                state.pendingTasks,
              )..insert(0, event.task.copyWith(isDeleted: false, isDone: false, isFavorite: false)),
              completedTasks: state.completedTasks,
              favoriteTasks: state.favoriteTasks,
              removedTasks: List.from(state.removedTasks)..remove(event.task),
              offlineDeleteTasks: state.offlineDeleteTasks,
            ),
          );
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            task = event.task.copyWith(isOffline: false);
            emit(
              TasksState(
                pendingTasks: List.from(state.pendingTasks)..insert(
                  0,
                  event.task.copyWith(isDeleted: false, isDone: false, isFavorite: false),
                ),
                completedTasks: state.completedTasks,
                favoriteTasks: state.favoriteTasks,
                removedTasks: List.from(state.removedTasks)..remove(event.task),
                offlineDeleteTasks: state.offlineDeleteTasks,
              ),
            );
          });
        },
      );
    } else {
      task = event.task.copyWith(isOffline: true);
      emit(
        TasksState(
          pendingTasks: List.from(state.pendingTasks)
            ..insert(0, event.task.copyWith(isDeleted: false, isDone: false, isFavorite: false)),
          completedTasks: state.completedTasks,
          favoriteTasks: state.favoriteTasks,
          removedTasks: List.from(state.removedTasks)..remove(event.task),
          offlineDeleteTasks: state.offlineDeleteTasks,
        ),
      );
    }
  }

  void _onDeleteAllTasks(DeleteAllTasks event, Emitter<TasksState> emit) async {
    final state = this.state;
    final offlineDeleteTasks =
        state.removedTasks.where((task) => task.isOffline == false).map((task) => task.id).toList();
    if (internetStatus && offlineDeleteTasks.isNotEmpty) {
      final result = await validityCheck.checkAndProceedToDataSource(
        deleteBatchTaskDataSource,
        data: offlineDeleteTasks,
      );
      result.fold(
        (failure) {
          emit(
            TasksState(
              removedTasks: List.from(state.removedTasks)..clear(),
              pendingTasks: state.pendingTasks,
              completedTasks: state.completedTasks,
              favoriteTasks: state.favoriteTasks,
              offlineDeleteTasks: List.from(
                <String>{...state.offlineDeleteTasks, ...offlineDeleteTasks}.toSet().toList(),
              ),
            ),
          );
        },
        (loaded) {
          loaded.fold((f) {}, (r) async {
            emit(
              TasksState(
                removedTasks: List.from(state.removedTasks)..clear(),
                pendingTasks: state.pendingTasks,
                completedTasks: state.completedTasks,
                favoriteTasks: state.favoriteTasks,
                offlineDeleteTasks: List.from(state.offlineDeleteTasks)..clear(),
              ),
            );
          });
        },
      );
    } else {
      emit(
        TasksState(
          removedTasks: List.from(state.removedTasks)..clear(),
          pendingTasks: state.pendingTasks,
          completedTasks: state.completedTasks,
          favoriteTasks: state.favoriteTasks,
          offlineDeleteTasks: List.from(
            <String>{...state.offlineDeleteTasks, ...offlineDeleteTasks}.toSet().toList(),
          ),
        ),
      );
    }
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    print("called fromJson = ${json.toString()}");
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    print("called toJson: ${state.toMap()}");

    return state.toMap();
  }

  void _onClearAllTask(ClearAllTask event, Emitter<TasksState> emit) {
    emit(
      TasksState(
        pendingTasks: [],
        completedTasks: [],
        favoriteTasks: [],
        removedTasks: [],
        offlineDeleteTasks: [],
      ),
    );
    HelperUser.logout();
  }
}
