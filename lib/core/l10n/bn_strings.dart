/// All Bangla copy in one module, lifted **verbatim** from the live web app
/// (`project-kitchen-ready.lovable.app`) — never re-translated.
///
/// Bangla-only in v1, so no localisation machinery — plain constants to be
/// referenced across widgets.
abstract final class BnStrings {
  static const appTitle = 'রোগসেবা';

  // ---- Home hero ----
  static const heroTitle = 'আপনার লক্ষণ বলুন — তাৎক্ষণিক স্বাস্থ্য পরামর্শ পান';
  static const heroSubtitle =
      'বাংলায় কথা বলে বা লিখে জানান কী হচ্ছে। RogSheba বলে দেবে — '
      'ঘরে যত্ন যথেষ্ট, না কি ডাক্তার দেখানো জরুরি।';

  // ---- Symptom entry ----
  static const symptomPlaceholder =
      'আপনার লক্ষণ বাংলায় লিখুন বা মাইকে কথা বলুন… '
      '(যেমন: গত ৩ দিন ধরে গলা ব্যথা ও জ্বর ১০১°F)';
  static const clearField = 'মুছে ফেলুন';

  // ---- Submit ----
  static const submit = 'পরামর্শ নিন';
  static const submitting = 'বিশ্লেষণ চলছে';
  static const inlineDisclaimer = 'এটি ডাক্তারের পরামর্শের বিকল্প নয়।';

  // ---- Examples ----
  static const exampleHeader = 'উদাহরণ';
  static const exampleFeverThroat = '৩ দিন ধরে জ্বর ১০২ ও গলা ব্যথা';
  static const exampleChestPain = 'বুকে চাপ ব্যথা, বাম হাতে ব্যথা';
  static const exampleStomach = 'পেট খারাপ ও বমি, ১ দিন ধরে';

  // ---- Feature strip ----
  static const featureTriageTitle = 'AI ট্রায়াজ';
  static const featureTriageBody =
      'সবুজ / হলুদ / লাল — তাৎক্ষণিক জরুরি মূল্যায়ন';
  static const featureClinicsTitle = 'নিকটস্থ ক্লিনিক';
  static const featureClinicsBody = 'GPS দিয়ে ১০ কিমির মধ্যে হাসপাতাল';
  static const featurePrivateTitle = 'প্রাইভেট ও বিনামূল্যে';
  static const featurePrivateBody = 'কোনো রেজিস্ট্রেশন নেই, কোনো ফি নেই';

  // ---- Errors ----
  static const genericError = 'একটি ত্রুটি ঘটেছে।';
  static const networkError =
      'ইন্টারনেট সংযোগ নেই। সংযোগ ঠিক করে আবার চেষ্টা করুন।';
  static const timeoutError =
      'অনুরোধটি সময় শেষ হয়ে গেছে। সংযোগ ঠিক করে আবার চেষ্টা করুন।';

  // ---- Triage result card headings ----
  static const levelGreen = 'সবুজ — ঘরে যত্ন';
  static const levelGreenSub = 'নিম্ন জরুরি';
  static const levelYellow = 'হলুদ — ক্লিনিকে যান';
  static const levelYellowSub = 'মাঝারি জরুরি — ২৪ ঘণ্টার মধ্যে';
  static const levelRed = 'লাল — এখনই হাসপাতালে যান';
  static const levelRedSub = 'জরুরি — দেরি করবেন না';

  static const adviceTitle = 'করণীয়';
  static const warningSignsTitle = 'বিপদ-সংকেত — দেখলে দ্রুত হাসপাতালে যান';
  static const followupPrefix = 'ফলো-আপ: ';
  static const ttsListen = 'বাংলায় শুনুন';
  static const ttsStop = 'শোনা বন্ধ';
  static const redBanner = 'এখনই হাসপাতালে যান বা জরুরি সেবায় কল করুন';
  static const call999 = '৯৯৯ কল';
  static const call16263 = '১৬২৬৩';
  static const nearbyClinicsCta = 'নিকটস্থ ক্লিনিক খুঁজুন';
}
