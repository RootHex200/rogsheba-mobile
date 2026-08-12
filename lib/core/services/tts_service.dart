import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads a triage result aloud in Bangla — the counterpart to speech input for
/// users who cannot read comfortably.
///
/// Narrow by design: the UI and tests depend only on this contract, never on
/// `flutter_tts` directly.
abstract interface class TtsService {
  /// Whether a `bn-BD` voice is installed. When false, the speaker button is
  /// hidden rather than reading Bangla text with an English voice.
  Future<bool> supportsBanglaVoice();

  /// Speaks [text] at the web rate (0.95), interrupting any current utterance.
  Future<void> speak(String text);

  /// Stops and discards any current utterance, freeing the audio channel.
  Future<void> stop();
}

/// Real implementation backed by `flutter_tts`, configured for `bn-BD` at the
/// web's rate of 0.95.
class FlutterTtsService implements TtsService {
  FlutterTtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  @override
  Future<bool> supportsBanglaVoice() async {
    final languages = await _tts.getLanguages;
    if (languages is! List) return false;
    return languages.any((code) => code.toString().startsWith('bn'));
  }

  @override
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.setLanguage('bn-BD');
    await _tts.setSpeechRate(0.95);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}

/// Composition root. Tests override this with a hand-written fake.
final ttsServiceProvider = Provider<TtsService>((ref) => FlutterTtsService());
