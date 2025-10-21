import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_006/features/timer/application/timer_bloc.dart';
import 'package:practica_006/features/timer/data/repositories/timer_repository_impl.dart';
import 'package:practica_006/features/timer/domain/entities/ticker.dart';
import 'package:practica_006/features/timer/presentation/widgets/actions_buttons.dart';
import 'package:practica_006/features/timer/presentation/widgets/background.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(
        timerRepository: TimerRepositoryImpl(
          const Ticker(),
        ),
      ),
      child: const _TimerView(),
    );
  }
}

class _TimerView extends StatelessWidget {
  const _TimerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Positioned.fill(
            child: SingleChildScrollView(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: orientation == Orientation.portrait
                                ? 100.0
                                : 20.0), // Reduced padding for landscape
                        child: Center(
                          child: BlocBuilder<TimerBloc, TimerState>(
                            builder: (context, state) {
                              final String minutesStr = ((state.duration / 60) % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              final String secondsStr = (state.duration % 60)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: CircularProgressIndicator(
                                      value: state.initialDuration > 0
                                          ? state.duration / state.initialDuration
                                          : 1.0,
                                      strokeWidth: 10,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (state is TimerInitial) {
                                        _showDurationDialog(context, state.duration);
                                      }
                                    },
                                    child: Text(
                                      '$minutesStr:$secondsStr',
                                      style: const TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const ActionsButtons(),
                      const _LapsView(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDurationDialog(BuildContext context, int currentDuration) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<TimerBloc>(context),
          child: Builder(builder: (context) {
            return AlertDialog(
              title: const Text('Set Duration (in minutes)'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter duration in minutes',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newDuration = int.tryParse(controller.text);
                    if (newDuration != null) {
                      context
                          .read<TimerBloc>()
                          .add(TimerStarted(duration: newDuration * 60));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Start'),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

class _LapsView extends StatelessWidget {
  const _LapsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state.laps.isEmpty) { // Modified condition
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 150.0,
          child: ListView.builder(
            itemCount: state.laps.length,
            itemBuilder: (context, index) {
              final duration = state.laps[index];
              final minutesStr = ((duration / 60) % 60)
                  .floor()
                  .toString()
                  .padLeft(2, '0');
              final secondsStr =
                  (duration % 60).floor().toString().padLeft(2, '0');
              return ListTile(
                title: Text('Lap ${state.laps.length - index}'),
                trailing: Text('$minutesStr:$secondsStr'),
              );
            },
          ),
        );
      },
    );
  }
}
