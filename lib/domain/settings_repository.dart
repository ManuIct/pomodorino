import '../models/timer_settings.dart';

abstract class SettingsRepository {
  Future<TimerSettings> getSettings();
  Future<void> saveSettings(TimerSettings settings);
}