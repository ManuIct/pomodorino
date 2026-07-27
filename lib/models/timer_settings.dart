class TimerSettings {
  final int focusMinutes;
  final int roundsBeforeBreak;
  final int breakMinutes;

  const TimerSettings({
    this.focusMinutes = 25,
    this.roundsBeforeBreak = 4,
    this.breakMinutes = 5,
  });
  
  TimerSettings copyWith({
    int? focusMinutes,
    int? roundsBeforeBreak,
    int? breakMinutes,
  }) {
    return TimerSettings(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      roundsBeforeBreak: roundsBeforeBreak ?? this.roundsBeforeBreak,
      breakMinutes: breakMinutes ?? this.breakMinutes,
    );
  }
}
