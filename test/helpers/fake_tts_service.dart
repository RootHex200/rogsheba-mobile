import 'dart:async';

import 'package:rogsheba_mobile/core/services/tts_service.dart';

/// Hand-written fake for widget tests: `FlutterTtsService` crosses a platform
/// channel and cannot run under `flutter_test`.
///
/// Mirrors the real behaviour of `awaitSpeakCompletion(true)`: [speak] returns
/// a future that does not resolve until the utterance is finished — which
/// [stop] performs — so an in-progress "stop" state is observable in tests.
class FakeTtsService implements TtsService {
  FakeTtsService({this.banglaVoiceAvailable = true});

  /// Defaults to true so existing tests keep rendering the speaker button.
  final bool banglaVoiceAvailable;

  /// Every text passed to [speak], in order.
  final List<String> spokenTexts = [];

  int stopCalls = 0;

  final _pendingSpeech = <Completer<void>>[];

  @override
  Future<bool> supportsBanglaVoice() async => banglaVoiceAvailable;

  @override
  Future<void> speak(String text) {
    spokenTexts.add(text);
    final completer = Completer<void>();
    _pendingSpeech.add(completer);
    return completer.future;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    for (final completer in _pendingSpeech) {
      if (!completer.isCompleted) completer.complete();
    }
    _pendingSpeech.clear();
  }
}
