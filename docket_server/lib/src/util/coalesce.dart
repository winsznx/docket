import 'dart:async';

/// Folds bursts of events inside [window] into one, emitted at the end of the
/// window (PRD 12). The first event of a quiet stream opens the window.
class Coalesce<T> extends StreamTransformerBase<T, void> {
  const Coalesce(this.window);

  final Duration window;

  @override
  Stream<void> bind(Stream<T> stream) {
    late StreamController<void> out;
    StreamSubscription<T>? sub;
    Timer? timer;
    out = StreamController<void>(
      onListen: () {
        sub = stream.listen(
          (_) => timer ??= Timer(window, () {
            timer = null;
            out.add(null);
          }),
          onError: out.addError,
          onDone: () {
            timer?.cancel();
            out.close();
          },
        );
      },
      onCancel: () async {
        timer?.cancel();
        await sub?.cancel();
      },
    );
    return out.stream;
  }
}
