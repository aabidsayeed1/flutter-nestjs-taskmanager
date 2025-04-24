import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/apis/base/custom_http_client.dart';
import 'package:task_manager/core/apis/update/get_app_update.dart';
import 'package:task_manager/core/generic/validity_check.dart';
import 'package:task_manager/features/login/data/datasources/login_data_source.dart';
import 'package:task_manager/features/login/data/datasources/otp_data_source.dart';
import 'package:task_manager/features/login/presentation/bloc/login_bloc.dart';
import 'package:task_manager/features/tasks/data/datasources/create_batch_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/create_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/delete_batch_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/delete_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/get_tasks_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/search_task_data_source.dart';
import 'package:task_manager/features/tasks/data/datasources/update_task_data_source.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';
import 'package:task_manager/route/global_navigator.dart';

import 'core/generic/user/cubit/user_cubit.dart';
import 'core/generic/user/user_details_data_souce.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => CustomHttpClient());
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => ValidityCheck());
  sl.registerLazySingleton(() => GetAppUpdateDataSource());
  injectUserCubit();
  injectTasks();
  injectLogin();
}

void injectUserCubit() {
  sl.registerFactory(() => UserCubit(sl(), getUserDataSource: sl()));
  sl.registerLazySingleton<UserDetailsDataSource>(() => UserDetailsDataSource(client: sl()));
}

void injectTasks() {
  sl.registerFactory(() => TasksBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(),sl()));
  sl.registerLazySingleton<CreateTaskDataSource>(() => CreateTaskDataSource(client: sl()));
  sl.registerLazySingleton<GetTaskDataSource>(() => GetTaskDataSource(client: sl()));
  sl.registerLazySingleton<UpdateTaskDataSource>(() => UpdateTaskDataSource(client: sl()));
  sl.registerLazySingleton<DeleteTaskDataSource>(() => DeleteTaskDataSource(client: sl()));
  sl.registerLazySingleton<CreateBatchTaskDataSource>(
    () => CreateBatchTaskDataSource(client: sl()),
  );
  sl.registerLazySingleton<DeleteBatchTaskDataSource>(
    () => DeleteBatchTaskDataSource(client: sl()),
  );
  sl.registerLazySingleton<SearchTaskDataSource>(
    () => SearchTaskDataSource(client: sl()),
  );
}

void injectLogin() {
  sl.registerFactory(
    () => LoginBloc(loginDataSource: sl(), validityCheck: sl(), otpDataSource: sl()),
  );
  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSource(client: sl()));
  sl.registerLazySingleton<OTPDataSource>(() => OTPDataSource(client: sl()));
}
