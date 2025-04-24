import 'package:task_manager/app_imports.dart';
import 'package:task_manager/core/managers/general/logging_manager.dart';
import 'package:task_manager/ui/app_widgets/atoms/custom_text_field.dart';
import 'package:task_manager/ui/atoms/button.dart';
import 'package:task_manager/ui/page_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    LoggingManager.logEvent(PageConstants.LOGIN, LoggingType.info, "in login page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController mobileTextFieldController = TextEditingController();

    final LoginBloc bloc = sl<LoginBloc>();
    // String? mobileErrorText;
    return BlocProvider<LoginBloc>(
      create: (context) => bloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          //HelperUI.hideLoader();
          if (state is LoginLoadedState) {
            CustomNavigator.pushTo(
              context,
              AppPages.PAGE_OTP_VERIFY,
              arguments: {'mobile': mobileTextFieldController.text},
            );
          }
          if (state is LoginMobileValidationErrorState) {
            // mobileErrorText = Utils.getLocalizedString(
            //     context, "STRING_MOBILE_VALIDATION_MESSAGE");
          }

          if (state is LoginValidatedState) {
            // mobileErrorText = null;
          }
          if (state is LoginErrorState) {}
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
                        children: [
                          SizedBox(height: 170.h),
                          CustomSpacers.height70,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Utils.getLocalizedString(context, "STRING_LOG_IN"),
                                  style: AppStyles.labelTextStyle,
                                ),
                                CustomSpacers.height8,
                                Text(
                                  Utils.getLocalizedString(context, "STRING_ENTER_MOBILE_NUMBER"),
                                  style: AppStyles.labelTextStyle,
                                ),
                              ],
                            ),
                          ),
                          CustomSpacers.height20,
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 48,
                                  width: 74,
                                  decoration: BoxDecoration(
                                    color: AppColors.CUSTOM_TEXT_FIELD_FILL,
                                    border: Border.all(
                                      color:
                                          (state is LoginErrorState)
                                              ? AppColors.CUSTOM_TEXT_FIELD_ERROR
                                              : AppColors.CUSTOM_TEXT_FIELD_FOCUSED,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "+91",
                                      style: AppStyles.textFieldInputStyle.copyWith(fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              CustomSpacers.width4,
                              Expanded(
                                flex: 4,
                                child: CustomTextField(
                                  showError: false,
                                  onChanged: (_) {
                                    Utils.printLogs(
                                      "mobileTextFieldController = ${mobileTextFieldController.text}",
                                    );

                                    if (mobileTextFieldController.text.length == 10) {
                                      bloc.add(const EnableLoginEvent(bEnable: true));
                                    } else {
                                      bloc.add(const EnableLoginEvent(bEnable: false));
                                    }
                                  },
                                  controller: mobileTextFieldController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  hint: Utils.getLocalizedString(context, "STRING_ENTER_NUMBER"),
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  errorText: (state is LoginErrorState) ? state.errorMessage : null,
                                  autoFocus: true,
                                ),
                              ),
                            ],
                          ),
                          CustomSpacers.height12,
                          if (state is LoginErrorState)
                            Text(state.errorMessage, style: AppStyles.textErrorStyle),
                          if (state is LoginErrorState) CustomSpacers.height24,
                          Button(
                            width: double.infinity,
                            strButtonText: Utils.getLocalizedString(context, "STRING_CONTINUE"),
                            size: ButtonSize.medium,
                            state:
                                mobileTextFieldController.text.length == 10
                                    ? ButtonState.active
                                    : ButtonState.disabled,
                            buttonAction: () async {
                              Utils.dismissKeypad(context);
                              bloc.add(LoginUserEvent(mobile: mobileTextFieldController.text));
                            },
                          ),

                          CustomSpacers.height12,
                          // if (state is LoginLoadingState)
                          //   SizedBox(
                          //       height: 30.h,
                          //       width: 30.h,
                          //       child: const CircularProgressIndicator())
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
