# RogSheba Mobile

Flutter (Android + iOS) port of the RogSheba web app — Bangla voice-first AI health triage for Bangladesh.

The backend is already built and public; this repo contains the mobile client only.

## Docs

| Doc | What it is |
|---|---|
| [`docs/prd/mobile-flutter-port.md`](docs/prd/mobile-flutter-port.md) | PRD — problem, solution, 59 user stories, implementation & testing decisions |
| [`docs/MOBILE_PLAN.md`](docs/MOBILE_PLAN.md) | Implementation plan — 5 phases × 2 parallel dev tracks, tech stack, design tokens |
| [`docs/MOBILE_API.md`](docs/MOBILE_API.md) | API contract for `/api/public/v1` |

## Stack

Flutter 3.32+ · Riverpod · Dio · freezed · go_router · speech_to_text · flutter_tts · geolocator

## Working agreement

- Issues are **vertical slices** — each cuts through every layer and is demoable on its own.
- `afk` issues can be picked up and merged without a human in the loop. `hitl` issues need a review or a decision.
- Bangla copy is lifted **verbatim** from the web app. Never re-translate.
- Tests assert user-visible behaviour only. One seam: `ProviderScope` overrides.
