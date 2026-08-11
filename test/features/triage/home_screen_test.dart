import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/app.dart';
import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/network_providers.dart';

import '../../helpers/fake_dio_adapter.dart';
import '../../helpers/fixtures.dart';

/// Pumps the real application widget with exactly one override: the HTTP
/// transport at the Dio adapter level. Everything above it — UTF-8 handling,
/// envelope decoding, error mapping, the repository and the screen — is real.
Future<FakeDioAdapter> pumpAppWithTransport(
  WidgetTester tester,
  Future<ResponseBody> Function(RequestOptions) handler,
) async {
  final adapter = FakeDioAdapter(handler);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dioProvider.overrideWith((ref) => Dio()..httpClientAdapter = adapter),
      ],
      child: const RogShebaApp(),
    ),
  );
  return adapter;
}

void main() {
  testWidgets('submit is disabled while the field is empty', (tester) async {
    final adapter = await pumpAppWithTransport(
      tester,
      (_) async => FakeDioAdapter.jsonBytes(triageEnvelope),
    );

    final submitButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, BnStrings.submit),
    );
    expect(submitButton.onPressed, isNull);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(adapter.requests, isEmpty);
  });

  testWidgets(
    'in-flight state shows Bangla progress and rejects a second tap',
    (tester) async {
      final gate = Completer<void>();
      final adapter = await pumpAppWithTransport(tester, (options) async {
        await gate.future;
        return FakeDioAdapter.jsonBytes(triageEnvelope);
      });

      await tester.enterText(find.byType(TextField), 'গলা ব্যথা আর জ্বর');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, BnStrings.submit));
      await tester.pump();

      expect(find.text(BnStrings.submitting), findsOneWidget);

      // A second submission attempt must be ignored.
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Dio reaches the adapter asynchronously; let pending microtasks run.
      await tester.idle();
      expect(adapter.requests, hasLength(1));

      final request = adapter.requests.single;
      expect(request.path, endsWith('/triage'));
      expect(
        (request.data as Map<String, dynamic>)['symptoms'],
        'গলা ব্যথা আর জ্বর',
      );

      gate.complete();
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'typed symptoms produce a rendered triage result through the real path',
    (tester) async {
      await pumpAppWithTransport(
        tester,
        (_) async => FakeDioAdapter.jsonBytes(triageEnvelope),
      );

      await tester.enterText(find.byType(TextField), 'গলা ব্যথা আর জ্বর');
      await tester.pump();
      await tester.tap(find.widgetWithText(ElevatedButton, BnStrings.submit));
      await tester.pumpAndSettle();

      expect(find.text('গলা ব্যথা ও জ্বর'), findsOneWidget);
      expect(find.textContaining('প্রচুর কুসুম গরম পানি'), findsOneWidget);
      expect(find.textContaining('শ্বাস নিতে কষ্ট হলে'), findsOneWidget);
      expect(
        find.text('এটি একজন ডাক্তারের পরামর্শের বিকল্প নয়।'),
        findsOneWidget,
      );
    },
  );

  testWidgets('a validation error from the API reaches the user verbatim', (
    tester,
  ) async {
    await pumpAppWithTransport(
      tester,
      (_) async =>
          FakeDioAdapter.jsonBytes(validationErrorEnvelope, status: 422),
    );

    await tester.enterText(find.byType(TextField), 'যা');
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, BnStrings.submit));
    await tester.pumpAndSettle();

    expect(find.text('Invalid request body.'), findsOneWidget);
    expect(find.text('গলা ব্যথা ও জ্বর'), findsNothing);
  });
}
