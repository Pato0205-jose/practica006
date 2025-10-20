/// The `TimerRepository` class in Dart provides a contract for
/// retrieving a stream of integer values representing time ticks.
abstract class TimerRepository {
  /// Returns a stream of integers that serve as time ticks.
  Stream<int> ticker();
}