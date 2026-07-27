import 'package:flutter/material.dart';
import '../models/timer_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_row.dart';
// keep Material available

class SettingsScreen extends StatefulWidget {
  final TimerSettings initialSettings;

  const SettingsScreen({super.key, required this.initialSettings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TimerSettings _settings = widget.initialSettings;
  

  void _save() {
    Navigator.of(context).pop(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _save,
        ),
        title: const Text(
          'Impostazioni',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            SettingsRow(
              label: 'Focus',
              unit: 'minuti di concentrazione',
              value: _settings.focusMinutes,
              min: 1,
              max: 90,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(focusMinutes: v)),
            ),
            const Divider(color: Colors.grey, height: 1),

            SettingsRow(
              label: 'Round prima della pausa',
              unit: 'sessioni di focus', 
              value: _settings.roundsBeforeBreak,
              min: 1,
              max: 12,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(roundsBeforeBreak: v)),
            ),
            const Divider(color: AppColors.border, height: 1),

            SettingsRow(
              label: 'Pausa',
              unit: 'minuti di pausa',
              value: _settings.breakMinutes,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(breakMinutes: v)),
            ),
            const Divider(color: AppColors.border, height: 1),
          ],
        ),
        ),
    );
  }
}

