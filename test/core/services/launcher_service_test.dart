import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/core/services/launcher_service.dart';

void main() {
  group('LauncherService.telUri', () {
    test('builds a bare phone-number tel URI', () {
      expect(LauncherService.telUri('999'), 'tel:999');
      expect(LauncherService.telUri('16263'), 'tel:16263');
      expect(LauncherService.telUri('+8801711223344'), 'tel:+8801711223344');
    });
  });
}
