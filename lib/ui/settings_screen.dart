import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodorino/di/settings_providers.dart';
import '../models/timer_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_row.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Impostazioni',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Errore: $err')),
        data: (settings) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              SettingsRow(
                label: 'Focus',
                unit: 'minuti di concentrazione',
                value: settings.focusMinutes,
                min: 1,
                max: 90,
                onChanged: (v) => _update(ref, settings, focusMinutes: v),
              ),
              const Divider(color: AppColors.border, height: 1),
              SettingsRow(
                label: 'Round prima della pausa',
                unit: 'sessioni di focus',
                value: settings.roundsBeforeBreak,
                min: 1,
                max: 12,
                onChanged: (v) => _update(ref, settings, roundsBeforeBreak: v),
              ),
              const Divider(color: AppColors.border, height: 1),
              SettingsRow(
                label: 'Pausa',
                unit: 'minuti di pausa',
                value: settings.breakMinutes,
                onChanged: (v) => _update(ref, settings, breakMinutes: v),
              ),
              const Divider(color: AppColors.border, height: 1),
            ],
          ),
        ),
      ),
    );
  }

  void _update(WidgetRef ref, TimerSettings current,
      {int? focusMinutes, int? roundsBeforeBreak, int? breakMinutes}) {
    ref.read(settingsControllerProvider.notifier).updateSettings(
          current.copyWith(
            focusMinutes: focusMinutes,
            roundsBeforeBreak: roundsBeforeBreak,
            breakMinutes: breakMinutes,
          ),
        );
  }
}