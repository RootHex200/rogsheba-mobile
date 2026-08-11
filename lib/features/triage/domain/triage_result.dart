import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';

/// Immutable triage result mirroring the `POST /triage` contract exactly.
///
/// Parsed leniently per the API's versioning note: unknown fields are ignored
/// and never cause a decode failure, and a missing/unrecognised `level` falls
/// back to [TriageLevel.yellow].
class TriageResult {
  const TriageResult({
    required this.level,
    required this.titleBn,
    required this.summaryBn,
    required this.adviceBn,
    required this.warningSignsBn,
    required this.disclaimerBn,
    required this.createdAt,
    this.followupQuestionBn,
    this.emergencyNumber,
  });

  factory TriageResult.fromJson(Map<String, dynamic> json) {
    return TriageResult(
      level: triageLevelFrom(json['level']),
      titleBn: json['title_bn'] as String? ?? '',
      summaryBn: json['summary_bn'] as String? ?? '',
      adviceBn: _asStringList(json['advice_bn']),
      warningSignsBn: _asStringList(json['warning_signs_bn']),
      followupQuestionBn: json['followup_question_bn'] as String?,
      disclaimerBn: json['disclaimer_bn'] as String? ?? '',
      emergencyNumber: json['emergency_number'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  final TriageLevel level;
  final String titleBn;
  final String summaryBn;
  final List<String> adviceBn;
  final List<String> warningSignsBn;

  /// One follow-up question, displayed for parity but not answerable in v1.
  final String? followupQuestionBn;

  /// Always render; this is preferred by the medical-app reviewers.
  final String disclaimerBn;

  /// `"999"` when [level] is red, otherwise `null`.
  final String? emergencyNumber;

  final String createdAt;

  static List<String> _asStringList(Object? value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList(growable: false);
  }
}
