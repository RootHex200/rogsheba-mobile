/// Clinical urgency of a triage result.
enum TriageLevel { green, yellow, red }

/// Parses the API's `level` string leniently.
///
/// A missing or unrecognised value is treated as [TriageLevel.yellow],
/// matching the server's own normalisation (`triage.server.ts`). Defaulting
/// toward caution is a deliberate safety decision: unparseable model output
/// must never resolve to "you are fine".
TriageLevel triageLevelFrom(Object? raw) {
  switch (raw) {
    case 'GREEN':
      return TriageLevel.green;
    case 'RED':
      return TriageLevel.red;
    case 'YELLOW':
      return TriageLevel.yellow;
    default:
      return TriageLevel.yellow;
  }
}
