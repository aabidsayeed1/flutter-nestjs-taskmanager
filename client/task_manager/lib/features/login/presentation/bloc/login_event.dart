part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUserEvent extends LoginEvent {
  final String mobile;
  final bool isResendingOTP;
  const LoginUserEvent({
    required this.mobile,
    this.isResendingOTP = false,
  });
}

class VerifyOTPEvent extends LoginEvent {
  final String mobile;
  final String otp;
  const VerifyOTPEvent({
    required this.mobile,
    required this.otp,
  });
}

class OTPTimerCompletedEvent extends LoginEvent {}

class OTPFlushErrorEvent extends LoginEvent {}

class EnableLoginEvent extends LoginEvent {
  final bool bEnable;

  const EnableLoginEvent({required this.bEnable});
}

class EnableOTPEvent extends LoginEvent {
  final bool bEnable;

  const EnableOTPEvent({required this.bEnable});
}
