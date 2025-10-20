// Provides a reusable interface for real-time websocket streams.
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Manages websocket connections and message broadcasting.
class RealTimeService {
  /// Creates a new [RealTimeService].
  RealTimeService({WebSocketChannel? channel})
    : _logger = Logger('RealTimeService'),
      _channel = channel;

  final Logger _logger;
  WebSocketChannel? _channel;
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  /// Connects to a websocket endpoint.
  void connect(String url) {
    disconnect();
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel?.stream.listen(
      (dynamic message) {
        if (message is String) {
          _messageController.add(message);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        _logger.warning('WebSocket error', error, stackTrace);
      },
    );
  }

  /// Sends a message through the socket if connected.
  void send(String message) {
    _channel?.sink.add(message);
  }

  /// Returns a broadcast stream of incoming messages.
  Stream<String> messages() => _messageController.stream;

  /// Closes the active websocket connection.
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  /// Disposes internal resources.
  void dispose() {
    disconnect();
    _messageController.close();
  }
}
