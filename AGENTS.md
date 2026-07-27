# AGENTS.md

Guidance for AI agents working in the Bazalt repository.

## What this is

Bazalt is an ERP engine based on the REA ontology (Resources, Events, Agents),
in Haskell (GHC 9.12.4) and Elm (0.19.2), with no database — pure event sourcing
over append-only JSON-lines files, state rebuilt in memory. The goal: model any
organization by configuration alone, no business-specific code. The product
positioning: **AI builds the ontology and the configuration; the code never
changes.** Every AI action is a message in the event log — visible, dated,
attributed, reversible.

Bazalt is the AI-assisted revival, as a single monorepo without history, of
ideas first developed by hand in the `modelyz-*` repositories
(github.com/ccomb). Design references (REA notes, the Hruby patterns book,
a real-world test case) live in the unversioned parent workspace directory.

## Monorepo layout

- `message/` — shared Haskell library: message and REA domain types. All services depend on it.
- `store/` — central event store and message router. WS server on **8081**. The only service others connect to.
- `studio/` — the app: `back/` (Haskell, HTTP + WS on **8080**, serves the SPA and relays browser ↔ store) and `front/` (Elm SPA).
- `ident/` — generates identifier sequences. Pure WS client of store.
- `dumb/` — placeholder processor: acknowledges every non-ident message as `Processed`. Pure WS client of store.

## Commands

```bash
./build.sh                    # build everything into build/ (cabal build all + install)
cabal build store             # any single package, from the root
<svc>/rundev.sh               # run one service against ./data/messagestore.txt
studio/rundev.sh              # build front + back, then run studio on :8080
studio/front/rundev.sh        # Elm live-reload via elm-go on :8080
studio/front/review.sh        # elm-review --fix-all
./build.docker.sh             # docker image (two-stage, COPY of local sources)
./run.compose.sh              # docker compose up with docker-compose.local.yml
```

Two hand-maintained knobs in `studio/front/build.sh`:
- `APPVERSION` — the build refuses if `studio/CHANGELOG.md` has no matching `## version N --` entry.
- `IDBVERSION` — **bump whenever any message JSON format changes**; it wipes the browser's IndexedDB store on upgrade.

## Architecture

```
browser (Elm + IndexedDB)
   ⇅ ws :8080
studio/back  ── ws :8081 ──►  store  ◄── ident
(HTTP :8080 serves SPA)         ▲────── dumb
```

Everything is JSON over WebSockets. Three levels of event sourcing: IndexedDB
in the browser, one append-only JSON-lines file per service
(`data/messagestore.txt`), and the store's file as the global source of truth.
Each process boots by folding its whole file into an in-memory `State`.

**Message model** (`message/src/`): `Message = Metadata + Payload`. `Metadata`
carries `uuid`, `when`, `flow` (`Requested | Processed | Error`) and `from`, a
*visit trail* of services (creator = head, appended at each hop — this is what
prevents routing loops). Identity is `MessageId = (uuid, flow)`: the same uuid
legitimately appears twice, once `Requested` and once `Processed`; every
service deduplicates against its `Set MessageId`. `Payload` has ~45
constructors (`{"what": …, "load": …}` in JSON) covering the seven REA
entities (Resource, Event, Agent, Commitment, Contract, Process, Group), their
seven `*Type` twins (self-parented hierarchies), plus identifiers, values,
expressions, scopes, configurations, group links and reconciliations.

**Lifecycle of one user action**: the browser wraps a payload as `Requested`
with `from=[Front]`, writes it to IndexedDB *first*, then sends over WS →
studio appends to its file and forwards → store appends, dedups, and routes
(`store/src/Main.hs` `routeMessage`: identifier-related payloads → ident, the
rest → dumb, everything → studio) → the processing service sends it back as
`Processed` → store routes to studio → all connected browsers fold it into
their state. `pending` in each service = seen `Requested`, not yet `Processed`.

**Sync on (re)connect**: a client sends `InitiatedConnection {lastMessageTime,
uuids}`; the server replies with every message not in that uuid set, then a
`Processed` `InitiatedConnection` as terminator. Deduplication is entirely by
uuid set. Clients replay their still-`Requested` messages after every
reconnect; reconnects back off exponentially.

**Elm app** (`studio/front/src/`): elm-spa routes (`Route.elm`: List/Add/Edit/View
pages for every entity and type), elm-ui only (no HTML/CSS). All browser IO
goes through ports whose JS lives inline in `src/index.html` (IndexedDB,
WebSocket, crypto seeds for client-side UUIDs). `State.elm` holds the
aggregated REA state; `State.aggregate` is the single fold applied by replaying
the entire IndexedDB log on every batch received. Display is
configuration-driven: `Configuration/Zone.elm` maps identifier fragments to
display zones per `Scope` — this is how the UI adapts to a modeled business
without code.

**Invariant to protect**: `message/src/Payload.hs` and
`studio/front/src/Payload.elm` (plus the surrounding types: `MessageFlow`,
`Metadata`, `Service`) are hand-kept mirrors — any change on one side must land
on the other, and usually means an `IDBVERSION` bump. Known asymmetry: Elm's
`MessageFlow.Error` carries no payload while Haskell's carries `Text`.

**Known rough edge**: routing in the store is hardcoded per payload
constructor; `message/src/Service.hs` contains a commented-out
`ServiceRegistry` sketch of the intended generic mechanism.

## Engineering rules

### Code safety (Haskell & Elm)
- **Make impossible states impossible** — use the type system.
- **Name domain values with their own type, not a bare primitive.** When a `Text`/`String`/`Int` carries domain meaning that crosses more than one signature — identifiers, uuids, units, amounts — wrap it in a `newtype` (Haskell) or opaque type (Elm), with a smart constructor where validation applies. Two guard-rails: don't wrap values that never leave a single expression (boilerplate ≠ safety), and when a comment is *enumerating* the valid strings, reach for a **sum type**, not a newtype.
- **No wildcard patterns on sum types** — exhaustive matches only. They hide incomplete matches from the compiler (applies to both Haskell and Elm).
- **No runtime crashes**: never use `error`, `throw`, `undefined`, or partial functions (`head`, `fromJust`). Functions that can fail must return `Either Text a` or `Maybe a`, never crash.
- **No silent errors or silent misbehaviour**: never return zero, empty, or a fallback value when a lookup fails or data is missing. Surface it — a value that silently undercounts is worse than a clear failure.
- Builds are `-Wall`-clean — introduce no new warnings.

### Code style
- Prefer short point-free style over explicit case pattern matching.
- Don't overload functions or write diagonal code (deeply nested, staircase-shaped logic). Extract, share and reuse relevant abstractions.
- **Pure domain, effectful edges**.
- Avoid long function signatures — split the function or gather arguments in a product type.
- Each type should have a sensible domain or technical meaning.
- Use advanced Haskell/Elm patterns when they improve expressivity and reduce line count.

### Design philosophy
- Think like "Out Of The Tar Pit": most complexity is accidental. Minimize mutable state, keep logic declarative, separate state / control / computation.
- Simplicity: perfection = nothing left to remove. Avoid over-engineering and cognitive load.
- **Pre-1.0: no backward-compatibility obligation** — keep wire formats and APIs clean rather than carrying cruft (bump `IDBVERSION` when the JSON changes).
- Use language servers for fast diagnostics (HLS for Haskell). Fix a diagnostic the moment you see it, even a pre-existing one — a separate small commit keeps it out of your feature's scope.

### Formatting
- Haskell is formatted with `fourmolu` (0.19.0.1, style in `fourmolu.yaml`) and linted with `hlint` (3.5, baselines in `.hlint.yaml`) — same tools and configs as the VoLCA engine. Don't hand-format.
- Elm is formatted with `elm-format` (devDependency in `studio/front`).

### Commits & PRs
- NEVER use `git add -A` — always add specific files explicitly.
- **Keep commit messages tight**: explain *why* the change was made and any non-obvious technical choices; don't restate the diff. Subject line + a few short paragraphs max.
- **Atomic commits — one subject per commit.** If the message needs "and also", split it.
- One PR = one subject. The PR description explains the why and the final state, not every commit.

### Documentation
- **Re-read this file + README before each PR.** Update them when: (a) you hit a statement contradicting the code, (b) a new convention appears, (c) a command or the topology changes. NON-trigger: adding a module or page that follows the stated conventions — the rules cover it, no list to grow.
- Never write hand-maintained counts or enumerations the code already knows — state the naming rule and point at the code.

### Privacy
- `data/` directories contain event logs that may hold real personal data. They are gitignored and must never be committed, copied into the repo, or pasted into issues/PRs.
