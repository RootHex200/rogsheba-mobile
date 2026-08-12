import 'dart:async';

import 'package:rogsheba_mobile/core/services/speech_service.dart';

/// Hand-written fake for widget tests: `speech_to_text` crosses a platform
/// channel and cannot run under `flutter_test`.
///
/// Exposes a broadcast stream the test drives with a realistic partial→final
/// sequence, mirroring the real recogniser.
class FakeSpeechService implements SpeechService {
  FakeSpeechService({this.banglaAvailable = true});

  /// Defaults to true so existing tests keep rendering the mic button.
  bool banglaAvailable;

  final StreamController<SpeechTranscript> _controller =
      StreamController<SpeechTranscript>.broadcast();

  int startCalls = 0;
  int stopCalls = 0;

  @override
  bool get isListening => startCalls > stopCalls;

  @override
  Stream<SpeechTranscript> get transcripts => _controller.stream;

  @override
  Future<bool> supportsBangla() async => banglaAvailable;

  @override
  Future<void> startListening() async {
    startCalls++;
  }

  @override
  Future<void> stopListening() async {
    stopCalls++;
  }

  /// Emits one transcript event; with [isFinal] it models an utterance ending.
  void emit(String text, {bool isFinal = false}) {
    _controller.add(SpeechTranscript(text, isFinal: isFinal));
  }

  void dispose() => _controller.close();
}
