import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/config/app_config.dart';

/// Single source of truth for the backend configuration. Every replaceable
/// dependency is provided through this graph so tests can override at the
/// `ProviderScope` boundary.
final configProvider = Provider<AppConfig>((_) => AppConfig.production);
