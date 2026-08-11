import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled font assets so renders use real glyphs instead of the
/// Ahem test font. Must run inside `tester.runAsync` because font loading is
/// real async I/O, which the fake-async test zone cannot drive directly.
Future<void> loadBundledFonts(WidgetTester tester) async {
  await tester.runAsync(() async {
    final bangla = FontLoader('Noto Sans Bengali')
      ..addFont(rootBundle.load('assets/fonts/NotoSansBengali-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/NotoSansBengali-Bold.ttf'));
    await bangla.load();

    final display = FontLoader('Plus Jakarta Sans')
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Bold.ttf'));
    await display.load();
  });
}
