import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class CustomStep extends StatelessWidget {
  final List<StepData> steps;

  final StepIndicatorType? stepIndicatorType;

  final bool switchTitlePosition;

  final bool isVertical;

  final double dividerLength;

  const CustomStep({
    Key? key,
    required this.steps,
    this.stepIndicatorType = StepIndicatorType.icon,
    this.switchTitlePosition = false,
    this.isVertical = false,
    this.dividerLength = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CUSTOM_STEP,
      child: SafeArea(child: isVertical ? _buildVertical() : _buildHorizontal()),
    );
  }

  ListView _buildVertical() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: steps.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment:
              switchTitlePosition ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (switchTitlePosition)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    steps[index].title ?? steps[index].stepType.toString(),
                    style: titleStyle(steps[index].stepType),
                  ),
                  const SizedBox(width: 8),
                  _stepIndicator(steps[index].stepType, index),
                ],
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _stepIndicator(steps[index].stepType, index),
                  const SizedBox(width: 8),
                  Text(
                    steps[index].title ?? steps[index].stepType.toString(),
                    style: titleStyle(steps[index].stepType),
                  ),
                ],
              ),

            //not to show line at the end
            if (index != steps.length - 1)
              Container(
                margin:
                    switchTitlePosition
                        ? EdgeInsets.only(
                          right: stepIndicatorType == StepIndicatorType.empty ? 4 : 16,
                        )
                        : EdgeInsets.only(
                          left: stepIndicatorType == StepIndicatorType.empty ? 4 : 16,
                        ),
                width: 2,
                height: dividerLength - 20,
                color:
                    steps[index].stepType == StepType.past
                        ? AppColors.PRIMARY_COLOR
                        : AppColors.STEPS_INACTIVE_COLOR,
              ),
          ],
        );
      },
    );
  }

  ListView _buildHorizontal() {
    return ListView.builder(
      itemCount: steps.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return SizedBox(
          width: dividerLength,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            clipBehavior: Clip.none,
            children: [
              //not to show line at the end
              if (index != steps.length - 1)
                Positioned(
                  left: 24,
                  child: Container(
                    margin:
                        switchTitlePosition
                            ? const EdgeInsets.only(top: 24)
                            : const EdgeInsets.only(bottom: 24),
                    height: 1,
                    width: dividerLength - 14,
                    color:
                        steps[index].stepType == StepType.past
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.STEPS_INACTIVE_COLOR,
                  ),
                ),

              if (switchTitlePosition)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      steps[index].title ?? steps[index].stepType.toString(),
                      style: titleStyle(steps[index].stepType),
                    ),
                    const SizedBox(height: 8),
                    _stepIndicator(steps[index].stepType, index),
                  ],
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _stepIndicator(steps[index].stepType, index),
                    const SizedBox(height: 8),
                    Text(
                      steps[index].title ?? steps[index].stepType.toString(),
                      style: titleStyle(steps[index].stepType),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Color indicatorIconColor(StepType stepType) {
    switch (stepType) {
      case StepType.past:
        return AppColors.BASICWHITE;

      case StepType.active:
        return AppColors.PRIMARY_COLOR;

      case StepType.next:
        return AppColors.STEPS_INACTIVE_COLOR;
    }
  }

  TextStyle titleStyle(StepType stepType) {
    switch (stepType) {
      case StepType.past:
        return AppStyles.stepsPastStyle;

      case StepType.active:
        return AppStyles.stepsActiveStyle;

      case StepType.next:
        return AppStyles.stepsNextStyle;
    }
  }

  Widget _stepIndicator(StepType stepType, int index) {
    switch (stepIndicatorType) {
      case StepIndicatorType.icon:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: stepType == StepType.past ? AppColors.PRIMARY_COLOR : AppColors.BASICWHITE,
            border: Border.all(
              color:
                  stepType == StepType.next
                      ? AppColors.STEPS_INACTIVE_COLOR
                      : AppColors.PRIMARY_COLOR,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              (index + 1).toString(),
              style:
                  steps[index].stepType == StepType.past
                      ? AppStyles.stepsPastIndicatorStyle
                      : titleStyle(steps[index].stepType),
            ),
          ),
        );

      case StepIndicatorType.noIcon:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: stepType == StepType.past ? AppColors.PRIMARY_COLOR : AppColors.BASICWHITE,
            border: Border.all(
              color:
                  stepType == StepType.next
                      ? AppColors.STEPS_INACTIVE_COLOR
                      : AppColors.PRIMARY_COLOR,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),

          //inner circle
          child: Center(
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: indicatorIconColor(stepType),
                border: Border.all(
                  color:
                      stepType == StepType.next
                          ? AppColors.STEPS_INACTIVE_COLOR
                          : AppColors.PRIMARY_COLOR,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        );
      case StepIndicatorType.empty:
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: stepType == StepType.past ? AppColors.PRIMARY_COLOR : AppColors.BASICWHITE,
            border: Border.all(
              color:
                  stepType == StepType.next
                      ? AppColors.STEPS_INACTIVE_COLOR
                      : AppColors.PRIMARY_COLOR,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      default:
        return Container();
    }
  }
}

class StepData {
  String? title;
  final StepType stepType;

  StepData({required this.stepType, this.title});
}
