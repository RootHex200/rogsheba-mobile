/// Recorded fixtures shaped exactly like the live API responses in
/// `docs/MOBILE_API.md`. All Bangla copy is verbatim from that doc.
const Map<String, dynamic> triageEnvelope = {
  'success': true,
  'data': {
    'level': 'YELLOW',
    'title_bn': 'গলা ব্যথা ও জ্বর',
    'summary_bn': 'আপনার লক্ষণ সম্ভবত গলার সংক্রমণ নির্দেশ করছে।',
    'advice_bn': ['প্রচুর কুসুম গরম পানি ও তরল খান', 'পর্যাপ্ত বিশ্রাম নিন'],
    'warning_signs_bn': ['শ্বাস নিতে কষ্ট হলে', 'জ্বর ১০৩°F এর বেশি হলে'],
    'followup_question_bn': 'আপনার কি ঢোক গিলতে খুব কষ্ট হচ্ছে?',
    'disclaimer_bn': 'এটি একজন ডাক্তারের পরামর্শের বিকল্প নয়।',
    'emergency_number': null,
    'created_at': '2026-08-05T15:10:22.481Z',
    // Unknown future field — must be ignored, never a decode failure.
    'some_future_field': {'nested': true},
  },
};

const Map<String, dynamic> validationErrorEnvelope = {
  'success': false,
  'error': {
    'code': 'validation_failed',
    'message': 'Invalid request body.',
    'details': [
      {
        'path': 'symptoms',
        'message': 'String must contain at least 3 character(s)',
      },
    ],
  },
};
