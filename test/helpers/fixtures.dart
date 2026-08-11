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

/// Bangla `error.message`, exactly as the API returns it. Must reach the UI
/// unmodified.
const Map<String, dynamic> banglaErrorEnvelope = {
  'success': false,
  'error': {
    'code': 'validation_failed',
    'message': 'অন্তত ৩টি অক্ষর লিখুন।',
  },
};

const Map<String, dynamic> rateLimitedEnvelope = {
  'success': false,
  'error': {
    'code': 'rate_limited',
    'message': 'অনেকগুলো অনুরোধ আসছে। কিছুক্ষণ পরে আবার চেষ্টা করুন।',
  },
};

const Map<String, dynamic> internalErrorEnvelope = {
  'success': false,
  'error': {
    'code': 'internal_error',
    'message': 'সার্ভিসে সাময়িক সমস্যা হয়েছে।',
  },
};
