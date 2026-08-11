import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/core/theme/app_theme.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';
import 'package:rogsheba_mobile/features/triage/presentation/triage_result_card.dart';

import '../helpers/bundled_fonts.dart';

/// Full-card goldens for the three triage levels, in light and dark.
/// Each render uses fixed representative content so the level colouring,
/// band, RED block, warning-signs block and follow-up are all visible.
const String _disclaimer = 'এটি একজন ডাক্তারের পরামর্শের বিকল্প নয়।';

TriageResult _resultFor(TriageLevel level) {
  return switch (level) {
    TriageLevel.green => TriageResult(
      level: level,
      titleBn: 'হালকা ঠান্ডা ও কাশি',
      summaryBn: 'আপনার লক্ষণ হালকা; বাড়িতেই যত্ন নিন।',
      adviceBn: const ['প্রচুর গরম পানি খান', 'পর্যাপ্ত বিশ্রাম নিন'],
      warningSignsBn: const [],
      disclaimerBn: _disclaimer,
      createdAt: '2026-08-11T00:00:00.000Z',
    ),
    TriageLevel.yellow => TriageResult(
      level: level,
      titleBn: 'গলা ব্যথা ও জ্বর',
      summaryBn: 'আপনার লক্ষণ সম্ভবত গলার সংক্রমণ নির্দেশ করছে।',
      adviceBn: const [
        'প্রচুর কুসুম গরম পানি ও তরল খান',
        'পর্যাপ্ত বিশ্রাম নিন',
      ],
      warningSignsBn: const ['শ্বাস নিতে কষ্ট হলে', 'জ্বর ১০৩°F এর বেশি হলে'],
      followupQuestionBn: 'আপনার কি ঢোক গিলতে খুব কষ্ট হচ্ছে?',
      disclaimerBn: _disclaimer,
      createdAt: '2026-08-11T00:00:00.000Z',
    ),
    TriageLevel.red => TriageResult(
      level: level,
      titleBn: 'বুকে তীব্র ব্যথা',
      summaryBn: 'জরুরি চিকিৎসা প্রয়োজন — দেরি করবেন না।',
      adviceBn: const ['শান্ত থাকুন', 'জরুরি সেবায় কল করুন'],
      warningSignsBn: const ['বুকে ক্রমাগত ব্যথা', 'ঠান্ডা ঘাম আসা'],
      disclaimerBn: _disclaimer,
      createdAt: '2026-08-11T00:00:00.000Z',
    ),
  };
}

Future<void> _pumpCard(
  WidgetTester tester,
  TriageLevel level,
  Brightness brightness,
) async {
  await tester.binding.setSurfaceSize(const Size(414, 1350));
  await loadBundledFonts(tester);
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: buildAppTheme(brightness),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TriageResultCard(result: _resultFor(level)),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final (level, theme, label) in [
    (TriageLevel.green, Brightness.light, 'green_light'),
    (TriageLevel.green, Brightness.dark, 'green_dark'),
    (TriageLevel.yellow, Brightness.light, 'yellow_light'),
    (TriageLevel.yellow, Brightness.dark, 'yellow_dark'),
    (TriageLevel.red, Brightness.light, 'red_light'),
    (TriageLevel.red, Brightness.dark, 'red_dark'),
  ]) {
    testWidgets('triage result card — $label', (tester) async {
      await _pumpCard(tester, level, theme);
      await expectLater(
        find.byType(TriageResultCard),
        matchesGoldenFile('triage_result_card_$label.png'),
      );
    });
  }
}
