import 'package:practica_006/features/timer/domain/repositories/timer_repository.dart';
import 'package:practica_006/features/timer/domain/entities/ticker.dart';

/// La clase `TimerRepositoryImpl` implementa la interfaz `TimerRepository`
/// y proporciona un stream de ticks utilizando una instancia de `Ticker`
/// inyectada.
class TimerRepositoryImpl implements TimerRepository {
  /// Constructor que recibe y almacena la dependencia del Ticker.
  TimerRepositoryImpl(this._ticker);

  /// La instancia privada del Ticker, que contiene la lógica pura del dominio.
  final Ticker _ticker;

  /// Implementación del método del contrato. Delega la llamada a la entidad Ticker.
  @override
  Stream<int> ticker() => _ticker.tick();
}