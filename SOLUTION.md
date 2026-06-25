# Solution Overview

A quick walkthrough of how I approached the challenge — what I chose, what I skipped, and what I'd do differently with a bit more time.

## Architecture Decisions

### MVVM + Combine

I split the app into four feature modules, each with a SwiftUI view and a `@MainActor` view model:

- **CatBreeds** — browse breeds with pagination
- **CatBreedDetail** — breed details
- **AddCat** — multi-step form to register a cat
- **RegisteredCats** — list of locally saved cats

Views stay mostly declarative. View models hold the state and talk to services through Combine. That way the UI doesn't know anything about Moya, URLs, or `UserDefaults` — it just reacts to published properties.

### Organized by feature, not by layer

Instead of a big `Views/` and `ViewModels/` folder at the root, each screen lives in its own module under `Sources/Modules/`. Shared stuff — buttons, cards, theme tokens — stays in `Components/` and `Theme/`. It felt like the right balance for a project this size: easy to navigate without over-engineering it.

### Built on top of the existing NetworkLayer

The networking module was already in good shape, so I tried not to reinvent it. I mostly extended what was there:

- Added `page` and `limit` query params to `CatInformationTarget`
- Exposed `getCatBreeds(page:limit:)` on `CatInformationService`

That kept things consistent with how the project was set up and made the service easy to mock in tests.

### Local storage through a protocol

For saving cats, I went with `UserDefaults` behind a `RegisteredCatStorageType` protocol. Honestly, Core Data would be overkill here — we're storing a small list of cats that the user adds manually. The protocol still matters though: the view model depends on the abstraction, not on `UserDefaults` directly, which made unit testing straightforward.

### Keeping saved cats in sync across tabs

When you save a cat in **Add Cat**, it should show up in **My Cats** right away — no restart needed. I handled that with a `RegisteredCatsStore` injected at the app level as an `EnvironmentObject`. It's a simple solution for three tabs. A bigger app would probably want a proper coordinator, but this worked well for the scope.

For tab switching (like sending someone from the empty **My Cats** state to **Add Cat**), I used a small `AppTab` enum with `TabView(selection:)`.

### Used the design system that was already there

The project came with `AppCard`, `AppButton`, `EmptyStateView`, `StepperIndicator`, and theme tokens — so I used them everywhere. Loading, empty, and error states look the same across screens, and I didn't spend time styling things from scratch.

---

## Trade-offs & Assumptions

**UserDefaults over Core Data / SwiftData**  
Good enough for a handful of saved cats. Quick to build, easy to test. Wouldn't scale if the app needed search, relationships, or a large dataset — but that wasn't the ask.

**EnvironmentObject for cross-tab state**  
Pragmatic for this app size. The downside is it gets harder to reason about as the app grows, since saved cats state lives globally rather than flowing through a dedicated navigation layer.

**Passing tab selection into `RegisteredCatsView`**  
The empty state needs to send the user to **Add Cat**. Passing a `$selectedTab` binding was the fastest way to do it. It works, but it means that view knows about app-level navigation — not ideal long term.

**Pagination triggered by `onAppear` on the last row**  
Standard SwiftUI approach, no extra dependencies. It can fire a touch early compared to scroll-position-based loading, but it's reliable and easy to follow.

**Using `CatBreed` directly in the UI**  
The API model is pretty large. I skipped mapping it to a slimmer domain type to save time. Fine for a challenge, but in production I'd probably introduce a presentation model.

**Tests focused on the Add Cat flow**  
That's where most of the custom logic lives — validation, step navigation, saving, persistence. I didn't get to breed pagination or UI tests within the time box.

**Other assumptions:**
- The Cat API key is set in `NetworkingTargetType.swift`
- Saved cats are append-only (no edit/delete needed for this scope)
- Single device, single user — no sync or migration
- Modern SwiftUI APIs (`navigationDestination`, `.refreshable`, `.task`) are fair game

---

## What I'd Improve With More Time

1. **A proper navigation layer** — Replace tab bindings and scattered environment objects with a lightweight coordinator or router.
2. **Better persistence** — SwiftData or Core Data if cats need editing, deleting, or filtering.
3. **More tests** — View model tests for pagination and error states, plus a few UI tests for the happy paths.
4. **Smarter networking** — Retry logic, clearer error messages, maybe caching breed results.
5. **Post-save UX** — Jump to **My Cats** after saving and fix the alert copy (it still mentions restarting the app).
6. **Slimmer models** — Map `CatBreed` to something views actually need instead of passing the full API response around.
7. **Image caching** — Breed photos reload from scratch every time right now.
8. **Accessibility pass** — VoiceOver labels, Dynamic Type, localized strings.
9. **Centralized DI** — A composition root to wire services instead of default arguments sprinkled across initializers.

---

## Project Structure

```
ApplaudoChallenge/
├── ApplaudoChallenge/Sources/
│   ├── Modules/          # Feature modules (MVVM)
│   ├── Components/       # Reusable SwiftUI components
│   ├── Services/         # Local persistence & shared stores
│   ├── Models/           # App-owned models (RegisteredCat)
│   └── Theme/            # Design tokens
└── modules/NetworkLayer/ # API layer (Moya + Combine)
```

Nothing fancy — just enough structure to find things quickly and add a new feature without reshuffling the whole project.
