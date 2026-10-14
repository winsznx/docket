import 'package:flutter/foundation.dart';

/// Whether the browser can speak, which it only knows once its voices load.
enum VoiceSupport { checking, available, unavailable }

/// Plays the call chime and speaks calls. The board talks to this, and the
/// browser version lives in `web_announcer.dart`.
abstract class Announcer {
  /// Whether a voice exists. The chime plays either way.
  ValueListenable<VoiceSupport> get voice;

  /// True once a tap or key press has let the page play sound.
  bool get unlocked;

  /// Called from inside a tap or key handler, since browsers only start
  /// audio and speech from a user gesture.
  Future<void> unlock();

  /// Queues one call: the chime when [chime] is on, then [speech] when
  /// [speak] is on and a voice exists. Calls play one after another.
  void announce(String speech, {required bool chime, required bool speak});

  void dispose();
}
