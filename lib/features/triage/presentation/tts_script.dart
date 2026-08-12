import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';

/// Assembles the text read aloud for a triage result, in the web's order:
/// headline, summary, then `করণীয়:` + advice items, then `বিপদ-সংকেত:` +
/// warning signs. Sections are separated by the Bengali danda so the TTS
/// engine reads each as its own sentence. Trailing dandas are trimmed so a
/// summary that already ends in one never reads as a double danda.
String buildSpeechText(TriageResult result) {
  final sections = <String>[
    result.titleBn,
    result.summaryBn,
    if (result.adviceBn.isNotEmpty)
      '${BnStrings.ttsAdvicePrefix}${result.adviceBn.join('। ')}',
    if (result.warningSignsBn.isNotEmpty)
      '${BnStrings.ttsWarningSignsPrefix}${result.warningSignsBn.join('। ')}',
  ];
  final text = sections.map(_trimTrailingDanda).join('। ');
  return text.isEmpty ? text : '$text।';
}

String _trimTrailingDanda(String section) =>
    section.replaceAll(RegExp(r'[\s।]+$'), '');
