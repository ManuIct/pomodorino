import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodorino/widgets/timer_ring.dart';
import '../models/timer_settings.dart';
import '../widgets/app_buttons.dart';
import 'settings_screen.dart';

enum PomodoroPhase { focus, breakTime }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimerSettings _settings = TimerSettings();

  PomodoroPhase _phase = PomodoroPhase.focus;
  int _currentRound = 1;
  bool _isRunning = false;

  late int _secondsRemaining = _settings.focusMinutes * 60;
  int _totalSecondsForPhase = 0;

  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _totalSecondsForPhase = _secondsRemaining;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
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

  void _reset() {
    _ticker?.cancel();
    setState(() {
      _isRunning = false;
      _phase = PomodoroPhase.focus;
      _currentRound = 1;
      _secondsRemaining = _settings.focusMinutes * 60;
      _totalSecondsForPhase = _secondsRemaining;
    });
  }

  void _onPhaseComplete() {
    _ticker?.cancel();

    setState(() {
      if (_phase == PomodoroPhase.focus) {
        if (_currentRound >= _settings.roundsBeforeBreak) {
          _phase = PomodoroPhase.breakTime;
          _secondsRemaining = _settings.focusMinutes * 60;
        } else {
          _currentRound++;
          _secondsRemaining = _settings.focusMinutes * 60;
        }
      } else {
        _phase = PomodoroPhase.focus;
        _currentRound = 1;
        _secondsRemaining = _settings.focusMinutes * 60;
      }
      _totalSecondsForPhase = _secondsRemaining;
      _isRunning = false;
    });
  }
   
  Future<void> _openSettings() async {
    final updated = await Navigator.of(context).push<TimerSettings>(
      MaterialPageRoute(builder: (_) => SettingsScreen(initialSettings: _settings)),
      );

      if (updated != null) {
        setState(() {
          _settings = updated;
          _reset();
        });
      }
  }

  String get _timeLabel {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress {
    if (_totalSecondsForPhase == 0) return 0;
    return 1 - (_secondsRemaining / _totalSecondsForPhase);
  }

  @override
  Widget build(BuildContext context) {
    final isFocus = _phase == PomodoroPhase.focus;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Pomodorino',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: _openSettings),
        ],
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
                  'Round $_currentRound di ${_settings.roundsBeforeBreak}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
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

              TextOnlyButton(label: 'Reset', onPressed: _reset),
            ],
          ),
          )
        ),
    );
  }
}
