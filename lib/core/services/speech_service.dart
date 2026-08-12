import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// One recognised unit of speech, streamed as **partial** results (updating
/// live while the user talks) and closed by a **final** result (the committed
/// transcript for that utterance).
class SpeechTranscript {
  const SpeechTranscript(this.text, {this.isFinal = false});

  final String text;

  /// `true` when the recogniser is done with this utterance and the text is
  /// safe to commit to the field.
  final bool isFinal;
}

/// Streams Bangla dictation for the symptom field — the counterpart to voice
/// output. Narrow by design: UI and tests depend only on this contract, never
/// on `speech_to_text` directly.
abstract interface class SpeechService {
  /// Whether `bn-BD` on-device recognition is available on this device.
  Future<bool> supportsBangla();

  /// Live dictation: partial transcripts updating while speaking, then a final
  /// transcript per utterance. Nothing is emitted while not listening.
  Stream<SpeechTranscript> get transcripts;

  /// Begins a listening session. Recognised text arrives on [transcripts].
  Future<void> startListening();

  /// Ends the current session; no further events are emitted.
  Future<void> stopListening();

  /// Whether a listening session is currently active.
  bool get isListening;
}

/// Real implementation backed by `speech_to_text`, configured for `bn-BD`
/// with partial results enabled so interim words can be rendered live.
class FlutterSpeechService implements SpeechService {
  FlutterSpeechService({SpeechToText? speech})
      : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  final StreamController<SpeechTranscript> _controller =
      StreamController<SpeechTranscript>.broadcast();

  bool? _initWorked;
  bool _listening = false;

  @override
  Stream<SpeechTranscript> get transcripts => _controller.stream;

  @override
  bool get isListening => _listening;

  Future<bool> _initialize() async {
    return _initWorked ??= await _speech.initialize();
  }

  @override
  Future<bool> supportsBangla() async {
    if (!await _initialize()) return false;
    final locales = await _speech.locales();
    return locales.any((l) => l.localeId.toLowerCase().startsWith('bn'));
  }

  @override
  Future<void> startListening() async {
    if (_listening || !await _initialize()) return;
    _listening = true;
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        localeId: 'bn-BD',
      ),
      onResult: (result) {
        if (!_controller.isClosed) {
          _controller.add(
            SpeechTranscript(
              result.recognizedWords,
              isFinal: result.finalResult,
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> stopListening() async {
    if (!_listening) return;
    _listening = false;
    await _speech.stop();
  }
}

/// Composition root. Tests override this with a hand-written fake.
final speechServiceProvider =
    Provider<SpeechService>((ref) => FlutterSpeechService());
