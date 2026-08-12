import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_result.dart';
import 'package:rogsheba_mobile/features/triage/presentation/tts_script.dart';

void main() {
  group('buildSpeechText', () {
    const result = TriageResult(
      level: TriageLevel.yellow,
      titleBn: 'গলা ব্যথা ও জ্বর',
      summaryBn: 'আপনার লক্ষণ সম্ভবত গলার সংক্রমণ নির্দেশ করছে।',
      adviceBn: ['প্রচুর কুসুম গরম পানি ও তরল খান', 'পর্যাপ্ত বিশ্রাম নিন'],
      warningSignsBn: ['শ্বাস নিতে কষ্ট হলে', 'জ্বর ১০৩°F এর বেশি হলে'],
      disclaimerBn: 'এটি একজন ডাক্তারের পরামর্শের বিকল্প নয়।',
      createdAt: '2026-08-05T15:10:22.481Z',
    );

    test('reads title, summary, advice and warning signs in web order', () {
      expect(
        buildSpeechText(result),
        'গলা ব্যথা ও জ্বর। '
        'আপনার লক্ষণ সম্ভবত গলার সংক্রমণ নির্দেশ করছে। '
        'করণীয়: প্রচুর কুসুম গরম পানি ও তরল খান। পর্যাপ্ত বিশ্রাম নিন। '
        'বিপদ-সংকেত: শ্বাস নিতে কষ্ট হলে। জ্বর ১০৩°F এর বেশি হলে।',
      );
    });

    test('omits empty advice and warning-sign sections', () {
      const sparse = TriageResult(
        level: TriageLevel.green,
        titleBn: 'শিরোনাম',
        summaryBn: 'সারাংশ।',
        adviceBn: [],
        warningSignsBn: [],
        disclaimerBn: '',
        createdAt: '',
      );
      expect(buildSpeechText(sparse), 'শিরোনাম। সারাংশ।');
    });
  });
}
