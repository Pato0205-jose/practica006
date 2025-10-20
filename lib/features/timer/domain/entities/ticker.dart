/// The `Ticker` class in Dart provides a stream of integers that emit a value every second.
class Ticker {
  const Ticker();

  /// Generates a stream of integers starting from 0,
  /// with a new value emitted every second.
  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x);
  }
}