import '../domain/settings_repository.dart';
import '../models/timer_settings.dart';
import 'settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<TimerSettings> getSettings() async {
    final data = await _dataSource.read();
    if (data == null) return const TimerSettings();
    return TimerSettings(
      focusMinutes: data['focusMinutes'] ?? 25,
      roundsBeforeBreak: data['roundsBeforeBreak'] ?? 4,
      breakMinutes: data['breakMinutes'] ?? 5,
    );
  }

  @override
  Future<void> saveSettings(TimerSettings settings) async {
    await _dataSource.write({
      'focusMinutes': settings.focusMinutes,
      'roundsBeforeBreak': settings.roundsBeforeBreak,
      'breakMinutes': settings.breakMinutes,
    });
  }
}