import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:task_manager/ui/atoms/button.dart';
import 'package:task_manager/ui/atoms/toast_message.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:task_manager/ui/molecules/otp_text_field.dart';
import 'package:task_manager/ui/page_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/login_bloc.dart';

class OTPVerifyPage extends StatefulWidget {
  final String phoneNumber;
  const OTPVerifyPage({super.key, required this.phoneNumber});

  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final TextEditingController otpTextFieldController = TextEditingController();
  String mobile = '';
  final LoginBloc bloc = sl<LoginBloc>();
  bool resendVisible = true;
  bool buttonEnabled = false;
  String? strErrorMessage;
  @override
  void initState() {
    mobile = widget.phoneNumber;
    LoggingManager.logEvent(PageConstants.OTP_VERIFY, LoggingType.info, "otp verify page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => bloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          //HelperUI.hideLoader();
          if (state is OTPVerifiedState) {
            // HelperUI.showTextLoader(
            //     color: Colors.white,
            //     opacity: 1,
            //     text: Utils.getLocalizedString(context, "INITIALISING"));
            CustomNavigator.pushNamedAndRemoveAll(context, AppPages.PAGE_DASHBOARD);
          }
          if (state is EnableOTPState) {
            buttonEnabled = state.bEnable;
          }

          if (state is OTPTimerCompletedState) {
            resendVisible = true;
          }
          if (state is OTPResentState) {
            resendVisible = false;
          }
          if (state is OTPFlushErrorState) {
            strErrorMessage = null;
          }
          if (state is OTPErrorState) {
            buttonEnabled = false;
            strErrorMessage = state.errorMessage;
            otpTextFieldController.clear();
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Utils.dismissKeypad(context);
              },
              child: Scaffold(
                backgroundColor: AppColors.OFF_WHITE_F4F4F5,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 170.h),

                          CustomSpacers.height70,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Utils.getLocalizedString(context, "STRING_VERIFICATION_CODE"),
                                  style: AppStyles.labelTextStyle,
                                ),
                                CustomSpacers.height8,
                                Text(
                                  Utils.getLocalizedString(context, "STRING_VERIFICATION_SENT_TO"),
                                  style: AppStyles.labelTextStyle,
                                ),
                                GestureDetector(
                                  onTapUp: (t) {
                                    CustomNavigator.pop(context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text("+91 $mobile", style: AppStyles.labelTextStyle),
                                      CustomSpacers.width4,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSpacers.height32,
                          SizedBox(
                            width: 215.w,
                            height: 48,
                            child: Semantics(
                              // value: AutomationConstants.PINCODE_TEXT_FIELD,
                              child: OTPTextField(
                                controller: otpTextFieldController,
                                length: 4,
                                keyboardType: TextInputType.number,
                                onChanged: (otp) {
                                  if (otp.length < 4) {
                                    if (buttonEnabled) {
                                      bloc.add(const EnableOTPEvent(bEnable: false));
                                    }
                                  } else {
                                    if (!buttonEnabled) {
                                      bloc.add(const EnableOTPEvent(bEnable: true));
                                    }
                                  }
                                },
                                onCompleted: (otp) => {},
                              ),
                            ),
                          ),
                          CustomSpacers.height10,
                          if (strErrorMessage != null)
                            Text(strErrorMessage!, style: AppStyles.labelTextStyle),
                          if (strErrorMessage != null) CustomSpacers.height18,
                          Row(
                            children: [
                              (!resendVisible)
                                  ? TweenAnimationBuilder<Duration>(
                                    duration: AppValues.RESEND_OTP_WAIT_DURATION,
                                    tween: Tween(
                                      begin: AppValues.RESEND_OTP_WAIT_DURATION,
                                      end: Duration.zero,
                                    ),
                                    onEnd: () {
                                      bloc.add(OTPTimerCompletedEvent());
                                    },
                                    builder: (BuildContext context, Duration value, Widget? child) {
                                      final seconds = (value.inSeconds % 60) + 1;
                                      return RichText(
                                        text: TextSpan(
                                          text: Utils.getLocalizedString(
                                            context,
                                            "STRING_RESEND_CODE_IN",
                                          ),
                                          style: AppStyles.labelTextStyle,
                                          children: [
                                            TextSpan(
                                              text: ' 00:$seconds',
                                              style: AppStyles.labelTextStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                  : TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft,
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      Utils.getLocalizedString(
                                        context,
                                        "STRING_DIDNT_RECEIVE_CODE",
                                      ),
                                      style: AppStyles.labelTextStyle,
                                    ),
                                  ),
                              TextButton(
                                onPressed: () {
                                  if (resendVisible) {
                                    LoggingManager.logEvent(
                                      mobile,
                                      LoggingType.info,
                                      "Resend clicked",
                                    );
                                    bloc.add(LoginUserEvent(mobile: mobile, isResendingOTP: true));
                                  }
                                },
                                child: Text(
                                  Utils.getLocalizedString(context, "STRING_RESEND"),
                                  // style: resendVisible
                                  //     ? AppStyles.openSans_600w_14_6F3895
                                  //     : AppStyles.openSans_600w_14_B79CCA,
                                ),
                              ),
                            ],
                          ),
                          CustomSpacers.height18,
                          Button(
                            width: double.infinity,
                            strButtonText: Utils.getLocalizedString(context, "STRING_VERIFY"),
                            size: ButtonSize.medium,
                            state: buttonEnabled ? ButtonState.active : ButtonState.disabled,
                            buttonAction: () async {
                              if (buttonEnabled) {
                                bloc.add(
                                  VerifyOTPEvent(mobile: mobile, otp: otpTextFieldController.text),
                                );
                              }
                            },
                          ),
                          CustomSpacers.height12,
                          // if (state is OTPLoadingState)
                          //   Center(
                          //     child: SizedBox(
                          //         height: 30.h,
                          //         width: 30.h,
                          //         child: const CircularProgressIndicator()),
                          //   )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
