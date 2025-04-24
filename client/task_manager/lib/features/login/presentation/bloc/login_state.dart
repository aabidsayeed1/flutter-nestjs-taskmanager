part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMessage;

  const LoginErrorState({required this.errorMessage});
}

class LoginValidationErrorState extends LoginState {
  final String errorMessage;

  const LoginValidationErrorState({required this.errorMessage});
}

class LoginMobileValidationErrorState extends LoginState {}

class OTPValidationErrorState extends LoginState {
  final String errorMessage;

  const OTPValidationErrorState({required this.errorMessage});
}

class LoginValidatedState extends LoginState {}

class OTPValidatedState extends LoginState {}

class OTPVerifiedState extends LoginState {}

class OTPTimerCompletedState extends LoginState {}

class OTPResentState extends LoginState {}

class OTPFlushErrorState extends LoginState {}

class OTPErrorState extends LoginState {
  final String errorMessage;

  const OTPErrorState({required this.errorMessage});
}

class OTPLoadingState extends LoginState {}

class EnableLoginState extends LoginState {}

class EnableOTPState extends LoginState {
  final bool bEnable;

  const EnableOTPState({required this.bEnable});
}
