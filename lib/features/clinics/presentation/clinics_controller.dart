import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rogsheba_mobile/core/l10n/bn_strings.dart';
import 'package:rogsheba_mobile/core/network/api_exception.dart';
import 'package:rogsheba_mobile/core/services/location_service.dart';
import 'package:rogsheba_mobile/features/clinics/data/clinics_repository.dart';
import 'package:rogsheba_mobile/features/clinics/domain/clinic.dart';

/// Which of the web's two distinct waiting states (or the terminal states)
/// the clinics screen is in.
enum ClinicsPhase { locating, loading, ready, failed }

class ClinicsViewState {
  const ClinicsViewState({
    this.phase = ClinicsPhase.locating,
    this.errorMessage,
    this.userLat,
    this.userLon,
    this.clinics = const [],
  });

  final ClinicsPhase phase;

  /// Already-Bangla message shown verbatim, only when [phase] is `failed`.
  final String? errorMessage;

  /// User position once granted, used as the maps-directions origin.
  final double? userLat;
  final double? userLon;
  final List<Clinic> clinics;
}

/// Drives the clinics screen: locate on open, then fetch nearest facilities.
class ClinicsController extends Notifier<ClinicsViewState> {
  @override
  ClinicsViewState build() => const ClinicsViewState();

  /// Auto-locate (no button press needed), then load. Idempotent per screen
  /// visit because the provider is auto-disposed when the route is popped.
  Future<void> locateAndLoad() async {
    state = const ClinicsViewState();
    final location = await ref.read(locationServiceProvider)();

    if (location is! LocationGranted) {
      // #8 owns only the granted path. The denied/disabled/failed recovery —
      // curated Dhaka fallback list plus the Bangla warning banner — is #9;
      // here the screen surfaces the failure so it never hangs silently.
      state = ClinicsViewState(
        errorMessage: switch (location) {
          LocationDenied() => BnStrings.locationDenied,
          LocationDisabled() => BnStrings.locationDisabled,
          LocationFailed() => BnStrings.locationFailed,
          LocationGranted() => BnStrings.locationFailed,
        },
      );
      return;
    }

    state = ClinicsViewState(
      phase: ClinicsPhase.loading,
      userLat: location.lat,
      userLon: location.lon,
    );
    try {
      final data = await ref
          .read(clinicsRepositoryProvider)
          .fetchNearby(lat: location.lat, lon: location.lon);
      // The server already sorts by distance, but re-sort client-side like the
      // web does so "nearest first" holds even past a reordering proxy.
      final sorted = [...data.clinics]
        ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      state = ClinicsViewState(
        phase: ClinicsPhase.ready,
        userLat: location.lat,
        userLon: location.lon,
        clinics: sorted,
      );
    } on ApiException catch (e) {
      state = ClinicsViewState(
        phase: ClinicsPhase.failed,
        errorMessage: e.message,
      );
    } catch (_) {
      state = const ClinicsViewState(
        phase: ClinicsPhase.failed,
        errorMessage: BnStrings.genericError,
      );
    }
  }
}

final clinicsControllerProvider =
    NotifierProvider.autoDispose<ClinicsController, ClinicsViewState>(
      ClinicsController.new,
    );
