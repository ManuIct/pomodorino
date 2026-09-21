import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_local_data_source.dart';
import '../data/settings_repository_impl.dart';
import '../domain/settings_repository.dart';
import '../models/timer_settings.dart';

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider));
});

class SettingsController extends AsyncNotifier<TimerSettings> {
  @override
  Future<TimerSettings> build() {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateSettings(TimerSettings settings) async {
    state = AsyncData(settings);
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, TimerSettings>(SettingsController.new);