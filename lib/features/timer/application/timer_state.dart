part of 'timer_bloc.dart';

/// The `sealed class TimerState extends Equatable` in Dart is defining a base class `TimerState` that
/// is marked as `sealed`. In Dart, a sealed class restricts its subclasses to be defined in the same
/// file. This helps in ensuring that all possible subclasses of `TimerState` are known and handled
/// within the same file.
sealed class TimerState extends Equatable {
  const TimerState(this.duration, this.initialDuration, this.laps);
  final int duration;
  final int initialDuration;
  final List<int> laps;

  @override
  List<Object> get props => [duration, initialDuration, laps];
}

/// The `TimerInitial` class represents the initial state of a timer with a specified duration in Dart.
class TimerInitial extends TimerState {
  const TimerInitial(int duration, {List<int> laps = const []}) : super(duration, duration, laps);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

/// The `TimerTicking` class represents the state of a timer that is currently ticking with a specific
/// duration.
class TimerTicking extends TimerState {
  const TimerTicking(int duration, int initialDuration, List<int> laps)
      : super(duration, initialDuration, laps);

  @override
  String toString() => 'TimerTicking { duration: $duration }';
}

/// The `TimerFinished` class represents a state where the timer has finished.
class TimerFinished extends TimerState {
  const TimerFinished({List<int> laps = const []}) : super(0, 0, laps);
}
