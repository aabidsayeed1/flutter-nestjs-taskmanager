import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/generic/validity_check.dart';
import 'package:task_manager/core/helpers/validators.dart';
import 'package:task_manager/features/login/data/datasources/login_data_source.dart';
import 'package:task_manager/features/login/data/datasources/otp_data_source.dart';
import 'package:task_manager/features/login/data/models/login_request_model.dart';
import 'package:task_manager/features/login/data/models/verify_otp_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/login/data/models/verify_otp_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginDataSource loginDataSource;
  final OTPDataSource otpDataSource;
  final ValidityCheck validityCheck;
  LoginBloc({
    required this.validityCheck,
    required this.loginDataSource,
    required this.otpDataSource,
  }) : super(LoginInitial()) {
    on<LoginUserEvent>((event, emit) async {
      if (Validators.validatePhoneNumber(event.mobile, 10) == false) {
        emit(LoginMobileValidationErrorState());
        return;
      }
      emit(LoginValidatedState());
      await HelperUI.showLoader();
      emit(LoginLoadingState());

      final result = await validityCheck.checkAndProceedToDataSource(
        loginDataSource,
        data: LoginRequestModel(mobile: event.mobile),
      );
      result.fold(
        (failure) {
          sleep(const Duration(seconds: 1));
          HelperUI.hideLoader();
          emit(LoginErrorState(errorMessage: failure));
        },
        (loaded) {
          HelperUI.hideLoader();
          if (event.isResendingOTP) {
            emit(OTPResentState());
          } else {
            emit(LoginLoadedState());
          }
        },
      );
    });

    on<VerifyOTPEvent>((event, emit) async {
      await HelperUI.showLoader();

      emit(OTPLoadingState());
      final result = await validityCheck.checkAndProceedToDataSource(
        otpDataSource,
        data: VerifyOTPRequestModel(mobile: event.mobile, otp: event.otp),
      );
      result.fold(
        (failure) {
          HelperUI.hideLoader();

          emit(OTPErrorState(errorMessage: failure));
          HelperUI.hideLoader();
        },
        (loaded) {
          HelperUI.hideLoader();
          loaded.fold((f) {}, (r) async {
            HelperUI.hideLoader();
            r as VerifyOTPResponseModel;
            HelperUser.setAuthToken(r.accessToken);
            HelperUser.setAccessToken(r.accessToken);
            HelperUser.setRefreshToken(r.refreshToken);
            emit(OTPVerifiedState());
          });
        },
      );
    });

    on<OTPTimerCompletedEvent>((event, emit) async {
      emit(LoginLoadingState());
      emit(OTPTimerCompletedState());
    });

    on<EnableLoginEvent>((event, emit) async {
      emit(LoginLoadingState());
      emit(EnableLoginState());
    });

    on<EnableOTPEvent>((event, emit) async {
      emit(LoginLoadingState());
      emit(EnableOTPState(bEnable: event.bEnable));
    });
    on<OTPFlushErrorEvent>((event, emit) async {
      emit(LoginLoadingState());
      emit(OTPFlushErrorState());
    });
  }
}
