import 'package:flutter/material.dart';
import 'package:pomodorino/theme/app_colors.dart';

class TimerRing extends StatelessWidget {
  final double progress;
  final String timeLabel;
  final String stateLabel;

  const TimerRing({
    super.key,
    required this.progress,
    required this.timeLabel,
    required this.stateLabel
    });

  @override
  Widget build(BuildContext context) {
    const size = 260.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            )
          )
        ]
      )
    );
  }
}