import 'package:flutter/material.dart';
import '../theme/app_colors.dart';



class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.label, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight:  FontWeight.w600),
          ),
          ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static void name({required String label, required void Function() onPressed}) {}
}
class TextOnlyButton extends StatelessWidget {
    final String label;
    final VoidCallback onPressed;


  const TextOnlyButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
      child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      );
  }
}

class AppIconButton extends StatelessWidget {
    final IconData icon;
    final VoidCallback onPressed;

  const AppIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
    icon: Icon(icon, color: AppColors.textPrimary),
    splashRadius: 24,
    );
  }
}