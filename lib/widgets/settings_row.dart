import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class AppStepper extends StatelessWidget {
  final String label;
  final String unit;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const AppStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99, required this.label, required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          onTap: value > min ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onTap: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled
              ? AppColors.accent
              : AppColors.textSecondary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String label;
  final String unit;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const SettingsRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.unit = 'min',
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                unit,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          AppStepper(
            label: label,
            unit: unit,
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
