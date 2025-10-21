import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:practica_006/features/timer/domain/repositories/timer_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

/// The TimerBloc class in Dart is responsible for managing timer events and states, utilizing a
/// TimerRepository for functionality like starting, ticking, pausing, and resetting timers.
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required TimerRepository timerRepository})
      : _timerRepository = timerRepository,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerReset>(_onReset);
    on<TimerLapPressed>(_onLapPressed);
  }

  final TimerRepository _timerRepository;
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const int _duration = 600;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerTicking(event.duration, event.duration, event.laps));
    _tickerSubscription?.cancel();
    _tickerSubscription = _timerRepository
        .ticker()
        .listen((ticks) => add(TimerTicked(duration: event.duration - ticks)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(TimerTicking(event.duration, state.initialDuration, state.laps));
    } else {
      _audioPlayer.play(AssetSource('audio/gota.mp3'));
      emit(TimerFinished(laps: state.laps));
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerTicking) {
      _tickerSubscription?.pause();
      emit(TimerInitial(state.duration, laps: state.laps));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _audioPlayer.stop();
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration, laps: []));
  }

  void _onLapPressed(TimerLapPressed event, Emitter<TimerState> emit) {
    if (state is TimerTicking) {
      final laps = [state.duration, ...state.laps];
      emit(TimerTicking(state.duration, state.initialDuration, laps));
    }
  }
}
