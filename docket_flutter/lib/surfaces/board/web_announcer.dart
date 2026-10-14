import 'dart:async';
import 'dart:collection';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'announcer.dart';

/// The browser announcer: a two-note chime made with the Web Audio API, then
/// the call read out by `speechSynthesis`. No audio files.
class WebAnnouncer implements Announcer {
  WebAnnouncer() {
    _watchVoices();
  }

  static const _voiceWait = Duration(seconds: 3);
  static const _speechTimeout = Duration(seconds: 12);
  static const _chimeLength = Duration(milliseconds: 1250);

  /// Calls that waited longer than this for the first tap are dropped, so
  /// a board left untapped doesn't read out the last hour.
  static const _staleAfter = Duration(minutes: 2);

  /// Speech a little slower than the default carries better across a
  /// noisy room.
  static const _rate = 0.9;

  final _voice = ValueNotifier(VoiceSupport.checking);
  final _queue = Queue<_Call>();
  web.AudioContext? _audio;
  web.SpeechSynthesisVoice? _chosen;
  Timer? _voiceTimer;
  bool _playing = false;
  bool _unlocked = false;
  bool _disposed = false;

  @override
  ValueListenable<VoiceSupport> get voice => _voice;

  @override
  bool get unlocked => _unlocked;

  static bool get _hasSpeech => web.window.has('speechSynthesis');

  void _watchVoices() {
    if (!_hasSpeech) {
      _voice.value = VoiceSupport.unavailable;
      return;
    }
    if (_pickVoice()) return;
    web.window.speechSynthesis.onvoiceschanged = ((web.Event _) {
      _pickVoice();
    }).toJS;
    _voiceTimer = Timer(_voiceWait, () {
      if (_voice.value == VoiceSupport.checking) {
        _voice.value = VoiceSupport.unavailable;
      }
    });
  }

  /// Picks an English voice, Nigerian or British English first since the
  /// clinics this was made for are in Lagos.
  bool _pickVoice() {
    final voices = web.window.speechSynthesis.getVoices().toDart;
    if (voices.isEmpty) return false;
    int rank(web.SpeechSynthesisVoice v) {
      final lang = v.lang.toLowerCase().replaceAll('_', '-');
      if (lang == 'en-ng') return 0;
      if (lang == 'en-gb') return 1;
      if (lang.startsWith('en')) return 2;
      return 3;
    }

    final sorted = [...voices]..sort((a, b) => rank(a) - rank(b));
    _chosen = sorted.first;
    _voiceTimer?.cancel();
    _voice.value = VoiceSupport.available;
    return true;
  }

  @override
  Future<void> unlock() async {
    final audio = _audio ??= web.AudioContext();
    if (audio.state != 'running') {
      await audio.resume().toDart;
    }
    if (_hasSpeech) {
      // An empty, silent utterance inside the gesture lets later speech
      // start without one.
      final primer = web.SpeechSynthesisUtterance(' ')..volume = 0;
      web.window.speechSynthesis.speak(primer);
    }
    _unlocked = true;
    _drain();
  }

  @override
  void announce(String speech, {required bool chime, required bool speak}) {
    _queue.add(_Call(speech, chime: chime, speak: speak));
    _drain();
  }

  Future<void> _drain() async {
    if (_playing || !_unlocked) return;
    _playing = true;
    while (_queue.isNotEmpty && !_disposed) {
      final call = _queue.removeFirst();
      if (DateTime.now().difference(call.queuedAt) > _staleAfter) continue;
      if (call.chime) {
        _chime();
        await Future<void>.delayed(_chimeLength);
      }
      if (call.speak && _voice.value == VoiceSupport.available) {
        await _say(call.speech);
      }
    }
    _playing = false;
  }

  /// A soft two-note "ding dong", E5 then C5, each with a quiet octave
  /// above it so it rings like a bell rather than a beep.
  void _chime() {
    final audio = _audio;
    if (audio == null) return;
    final start = audio.currentTime + 0.05;
    _tone(audio, 659.25, start, 0.9);
    _tone(audio, 523.25, start + 0.42, 1.1);
  }

  void _tone(web.AudioContext audio, double hz, double at, double length) {
    for (final (multiple, level) in [(1, 0.32), (2, 0.06)]) {
      final osc = audio.createOscillator()
        ..type = 'sine'
        ..frequency.value = hz * multiple;
      final gain = audio.createGain();
      gain.gain
        ..setValueAtTime(0.0001, at)
        ..exponentialRampToValueAtTime(level, at + 0.015)
        ..exponentialRampToValueAtTime(0.0001, at + length);
      osc
        ..connect(gain)
        ..start(at)
        ..stop(at + length + 0.05);
      gain.connect(audio.destination);
    }
  }

  Future<void> _say(String text) {
    final done = Completer<void>();
    void finish() {
      if (!done.isCompleted) done.complete();
    }

    final utterance = web.SpeechSynthesisUtterance(text)
      ..rate = _rate
      ..onend = ((web.Event _) => finish()).toJS
      ..onerror = ((web.Event _) => finish()).toJS;
    final voice = _chosen;
    if (voice != null) {
      utterance
        ..voice = voice
        ..lang = voice.lang;
    }
    web.window.speechSynthesis.speak(utterance);
    return done.future.timeout(_speechTimeout, onTimeout: finish);
  }

  @override
  void dispose() {
    _disposed = true;
    _voiceTimer?.cancel();
    _queue.clear();
    if (_hasSpeech) web.window.speechSynthesis.cancel();
    _audio?.close();
    _voice.dispose();
  }
}

class _Call {
  _Call(this.speech, {required this.chime, required this.speak});

  final String speech;
  final bool chime;
  final bool speak;
  final queuedAt = DateTime.now();
}
