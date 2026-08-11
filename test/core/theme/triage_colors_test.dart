import 'package:flutter_test/flutter_test.dart';
import 'package:rogsheba_mobile/core/theme/app_colors.dart';
import 'package:rogsheba_mobile/core/theme/triage_colors.dart';
import 'package:rogsheba_mobile/features/triage/domain/triage_level.dart';

void main() {
  group('TriageColors theme extension', () {
    test('light and dark resolve to the same token set (triage colours are '
        'brightness-independent)', () {
      const light = TriageColors.light();
      const dark = TriageColors.dark();

      expect(light.green, AppColors.triageGreen);
      expect(light.greenForeground, AppColors.triageGreenForeground);
      expect(light.yellow, AppColors.triageYellow);
      expect(dark.yellowForeground, AppColors.triageYellowForeground);
      expect(dark.red, AppColors.triageRed);
      expect(dark.redForeground, AppColors.triageRedForeground);
    });

    test('backgroundFor maps each level to its token', () {
      const triage = TriageColors.light();

      expect(
        triage.backgroundFor(TriageLevel.green, isForeground: false),
        AppColors.triageGreen,
      );
      expect(
        triage.backgroundFor(TriageLevel.yellow, isForeground: false),
        AppColors.triageYellow,
      );
      expect(
        triage.backgroundFor(TriageLevel.red, isForeground: false),
        AppColors.triageRed,
      );
      expect(
        triage.backgroundFor(TriageLevel.green, isForeground: true),
        AppColors.triageGreenForeground,
      );
      expect(
        triage.backgroundFor(TriageLevel.red, isForeground: true),
        AppColors.triageRedForeground,
      );
    });
  });
}
