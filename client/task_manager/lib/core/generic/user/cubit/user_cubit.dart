import 'package:equatable/equatable.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/generic/validity_check.dart';
import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';

import '../models/user_model.dart';
import '../user_details_data_souce.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final ValidityCheck validityCheck;
  final UserDetailsDataSource getUserDataSource;

  UserCubit(this.validityCheck, {required this.getUserDataSource}) : super(UserInitial());

  Future<void> fetchUserData() async {
    emit(UserLoading());
    final result = await validityCheck.checkAndProceedToDataSource(getUserDataSource);
    await result.fold(
      (failure) async {
        HelperUI.showToast(msg: failure.toString(), type: ToastType.error);
        emit(UserError("Failed to fetch user details: ${failure.toString()}"));
      },
      (loaded) async {
        await loaded.fold((f) {}, (r) async {
          r as UserModel;
          emit(UserLoaded(r));
        });
      },
    );
  }
}
