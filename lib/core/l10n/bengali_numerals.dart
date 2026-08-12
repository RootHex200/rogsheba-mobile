/// Convert ASCII digits (`'0'..'9'`) to their Bengali-script equivalents
/// (`'০'..'৯'`). Non-digit characters pass through unchanged.
///
/// Used by the emergency sheet so `৯৯৯` reads as Bengali even though the
/// `/emergency` endpoint returns Arabic. Keeping this next to the string
/// constants in `bn_strings.dart` puts every Bangla-chrome detail in one
/// module.
String toBengaliDigits(String input) {
  const map = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };
  final out = StringBuffer();
  for (final c in input.runes) {
    final ch = String.fromCharCode(c);
    out.write(map[ch] ?? ch);
  }
  return out.toString();
}
