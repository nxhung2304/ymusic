import 'dart:async';
import 'dart:collection';

const Duration _kDefaultThrottleDelay = Duration(seconds: 1);

class RequestQueue {
  final Queue<_QueueItem<dynamic>> _queue = Queue();
  final Duration delay;
  bool _isProcessing = false;

  RequestQueue({this.delay = _kDefaultThrottleDelay});

  Future<T> enqueue<T>(Future<T> Function() task) {
    final completer = Completer<T>();

    _queue.add(_QueueItem<T>(task, completer));
    _process();

    return completer.future;
  }

  void _process() {
    if (_isProcessing) return;
    _isProcessing = true;
    _run();
  }

  Future<void> _run() async {
    while (_queue.isNotEmpty) {
      final item = _queue.removeFirst();

      try {
        final result = await item.run();
        item.complete(result);
      } catch (e, stack) {
        item.completeError(e, stack);
      }

      if (_queue.isNotEmpty) {
        await Future.delayed(delay);
      }
    }

    _isProcessing = false;
  }
}

class _QueueItem<T> {
  final Future<T> Function() task;
  final Completer<T> completer;

  _QueueItem(this.task, this.completer);

  Future<T> run() => task();

  void complete(T value) => completer.complete(value);

  void completeError(Object error, StackTrace stack) {
    completer.completeError(error, stack);
  }
}
