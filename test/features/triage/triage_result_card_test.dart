import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/services/launcher_service.dart';
import 'package:rogsheba_mobile/core/theme/app_theme.dart';
import 'package:rogsheba_mobile/features/clinics/presentation/clinics_screen.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';
import 'package:rogsheba_mobile/features/triage/presentation/triage_result_card.dart';

class _RecordingLauncher implements LauncherService {
  final List<String> opened = <String>[];

  @override
  Future<bool> open(String uri) async {
    opened.add(uri);
    return true;
  }
}

TriageResult _result({
  TriageLevel level = TriageLevel.green,
  List<String> advice = const [
    'প্রচুর কুসুম গরম পানি ও তরল খান',
    'পর্যাপ্ত বিশ্রাম নিন',
  ],
  List<String> warningSigns = const ['জ্বর ১০৩°F এর বেশি হলে'],
  String? followup,
}) {
  return TriageResult(
    level: level,
    titleBn: switch (level) {
      TriageLevel.green => 'হালকা ঠান্ডা ও কাশি',
      TriageLevel.yellow => 'গলা ব্যথা ও জ্বর',
      TriageLevel.red => 'বুকে প্রচণ্ড ব্যথা',
    },
    summaryBn: 'লক্ষণ বিশ্লেষণ সম্পন্ন হয়েছে।',
    adviceBn: advice,
    warningSignsBn: warningSigns,
    followupQuestionBn: followup,
    disclaimerBn: 'এটি একজন ডাক্তারের পরামর্শের বিকল্প নয়।',
    createdAt: '2026-08-11T00:00:00.000Z',
  );
}

Future<_RecordingLauncher> _pumpCard(
  WidgetTester tester,
  TriageResult result,
) async {
  final launcher = _RecordingLauncher();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        launcherServiceProvider.overrideWithValue(launcher),
      ],
      child: MaterialApp(
        theme: buildAppTheme(Brightness.light),
        home: Scaffold(
          body: SingleChildScrollView(child: TriageResultCard(result: result)),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return launcher;
}

void main() {
  group('TriageResultCard — GREEN level', () {
    testWidgets(
        'shows the green band, title, advice, warning signs and follow-up',
        (tester) async {
      await _pumpCard(
        tester,
        _result(
          followup: 'আপনার কি ঢোক গিলতে খুব কষ্ট হচ্ছে?',
          warningSigns: const [
            'শ্বাস নিতে কষ্ট হলে',
            'জ্বর ১০৩°F এর বেশি হলে',
          ],
        ),
      );

      expect(find.text(BnStrings.levelGreen), findsOneWidget);
      expect(find.text(BnStrings.levelGreenSub), findsOneWidget);
      expect(find.text('হালকা ঠান্ডা ও কাশি'), findsOneWidget);

      expect(find.text(BnStrings.adviceTitle), findsOneWidget);
      expect(find.text('প্রচুর কুসুম গরম পানি ও তরল খান'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      expect(find.text(BnStrings.warningSignsTitle), findsOneWidget);
      expect(find.text('শ্বাস নিতে কষ্ট হলে'), findsOneWidget);
      expect(find.text('জ্বর ১০৩°F এর বেশি হলে'), findsOneWidget);

      expect(find.textContaining('ঢোক গিলতে খুব কষ্ট'), findsOneWidget);

      // No RED emergency block for a green result.
      expect(find.text(BnStrings.redEmergencyTitle), findsNothing);
      expect(find.text(BnStrings.call999), findsNothing);

      expect(
        find.textContaining('ডাক্তারের পরামর্শের বিকল্প নয়।'),
        findsOneWidget,
      );
    });
  });

  group('TriageResultCard — RED level', () {
    testWidgets(
      'shows emergency numbers and dials tel: URIs via the launcher',
      (tester) async {
      final launcher = await _pumpCard(tester, _result(level: TriageLevel.red));

      expect(find.text(BnStrings.levelRed), findsOneWidget);
      expect(find.text(BnStrings.redEmergencyTitle), findsOneWidget);

      await tester.tap(find.text(BnStrings.call999));
      await tester.tap(find.text(BnStrings.call16263));
      await tester.pump();

      expect(launcher.opened, ['tel:999', 'tel:16263']);
    });
  });

  group('TriageResultCard — clinics CTA', () {
    testWidgets('navigates to the placeholder ClinicsScreen', (tester) async {
      await _pumpCard(tester, _result());

      await tester.tap(find.text(BnStrings.nearbyClinicsCta));
      await tester.pumpAndSettle();

      expect(find.byType(ClinicsScreen), findsOneWidget);
      expect(find.text(BnStrings.clinicsAppBarTitle), findsOneWidget);
    });
  });
}
