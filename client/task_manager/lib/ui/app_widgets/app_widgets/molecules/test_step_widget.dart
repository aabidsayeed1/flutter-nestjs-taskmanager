import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/app_imports.dart';

class StepProgressWidget extends StatefulWidget {
  const StepProgressWidget({super.key});

  @override
  _StepProgressWidgetState createState() => _StepProgressWidgetState();
}

class _StepProgressWidgetState extends State<StepProgressWidget> {
  int currentStep = 0; // Tracks the current step

  @override
  void initState() {
    super.initState();
    _startStepProgress();
  }

  void _startStepProgress() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentStep < 3) {
        setState(() {
          currentStep++;
        });
      } else {
        timer.cancel(); // Stop the timer when all steps are completed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(0, "Scan \ndevices"),
        _buildLine(),
        _buildStep(1, "Register on \nCloud"),
        _buildLine(),
        _buildStep(2, "Initialize the \ndevice"),
      ],
    );
  }

  Widget _buildStep(int step, String label) {
    bool isCompleted = step < currentStep;
    bool isActive = step == currentStep;

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor:
              isCompleted
                  ? Colors
                      .blue // Completed step
                  : isActive
                  ? Colors
                      .blue // Current loading step
                  : Colors.grey, // Pending step
          child:
              isCompleted
                  ? const Icon(Icons.check, color: Colors.white) // Tick mark for completed
                  : isActive
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ) // Loading spinner
                  : null,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: Text(label, style: AppStyles.whiteBold12, maxLines: 2),
        ),
      ],
    );
  }

  Widget _buildLine() {
    return Container(width: 80.w, height: 2.h, color: currentStep > 0 ? Colors.blue : Colors.grey);
  }
}
