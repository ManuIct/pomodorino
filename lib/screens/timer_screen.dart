import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodorino/widgets/timer_ring.dart';
import '../di/settings_providers.dart';
import '../models/timer_settings.dart';
import '../ui/settings_screen.dart';
import '../widgets/app_buttons.dart';

enum PomodoroPhase { focus, breakTime }

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  PomodoroPhase _phase = PomodoroPhase.focus;
  int _currentRound = 1;
  bool _isRunning = false;
  int _secondsRemaining = 0;
  int _totalSecondsForPhase = 0;
  bool _initialized = false;

  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _initFromSettings(TimerSettings settings) {
    _secondsRemaining = settings.focusMinutes * 60;
    _totalSecondsForPhase = _secondsRemaining;
    _initialized = true;
  }

  void _start() {
    _ticker?.cancel();
    setState(() => _isRunning = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        _onPhaseComplete();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _pause() {
    _ticker?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset(TimerSettings settings) {
    _ticker?.cancel();
    setState(() {
      _isRunning = false;
      _phase = PomodoroPhase.focus;
      _currentRound = 1;
      _secondsRemaining = settings.focusMinutes * 60;
      _totalSecondsForPhase = _secondsRemaining;
    });
  }

  void _onPhaseComplete() {
    _ticker?.cancel();
    final settings = ref.read(settingsControllerProvider).value ?? const TimerSettings();

    setState(() {
      if (_phase == PomodoroPhase.focus) {
        if (_currentRound >= settings.roundsBeforeBreak) {
          _phase = PomodoroPhase.breakTime;
          _secondsRemaining = settings.breakMinutes * 60;
        } else {
          _currentRound++;
          _secondsRemaining = settings.focusMinutes * 60;
        }
      } else {
        _phase = PomodoroPhase.focus;
        _currentRound = 1;
        _secondsRemaining = settings.focusMinutes * 60;
      }
      _totalSecondsForPhase = _secondsRemaining;
      _isRunning = false;
    });
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  String get _timeLabel {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress =>
      _totalSecondsForPhase == 0 ? 0 : 1 - (_secondsRemaining / _totalSecondsForPhase);

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return settingsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Errore: $err'))),
      data: (settings) {
        if (!_initialized) _initFromSettings(settings);
        final isFocus = _phase == PomodoroPhase.focus;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            title: const Text('Pomodorino',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
            actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _openSettings)],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isFocus)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Round $_currentRound di ${settings.roundsBeforeBreak}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                    ),
                  TimerRing(
                    progress: _progress,
                    timeLabel: _timeLabel,
                    stateLabel: isFocus ? 'Focus' : 'Pausa',
                  ),
                  const SizedBox(height: 48),
                  if (!_isRunning)
                    PrimaryButton(label: 'Start', onPressed: _start)
                  else
                    SecondaryButton(label: 'Pausa', onPressed: _pause),
                  const SizedBox(height: 8),
                  TextOnlyButton(label: 'Reset', onPressed: () => _reset(settings)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}