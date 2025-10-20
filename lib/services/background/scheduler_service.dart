// Provides simple scheduling capabilities for background jobs.
import 'dart:async';

import 'package:logging/logging.dart';

/// Lightweight cron-like scheduler for periodic tasks.
class SchedulerService {
  /// Creates a new [SchedulerService].
  SchedulerService() : _logger = Logger('SchedulerService');

  final Logger _logger;
  final Map<String, Timer> _timers = {};

  /// Registers a recurring job identified by [id].
  void scheduleRecurring({
    required String id,
    required Duration interval,
    required void Function() task,
  }) {
    cancel(id);
    _logger.info('Scheduling recurring job $id every $interval');
    _timers[id] = Timer.periodic(interval, (_) => task());
  }

  /// Cancels a scheduled job.
  void cancel(String id) {
    _logger.info('Cancelling job $id');
    _timers.remove(id)?.cancel();
  }

  /// Disposes all active timers.
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
