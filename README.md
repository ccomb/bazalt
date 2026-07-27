# Bazalt

Bazalt is an ERP engine based on the REA ontology (Resources, Events, Agents): it models any organization by configuration alone — no business-specific code, no database. Everything is event sourcing over append-only files, with state rebuilt in memory.

## Origin

Bazalt is the AI-assisted revival, as a single monorepo, of ideas first developed by hand in the [modelyz-* repositories](https://github.com/ccomb?tab=repositories&q=modelyz). The event flow of the original design solidified here — like lava into basalt.

## Architecture

- `message/` — shared Haskell library: the message types and the REA domain (Resource, Event, Agent, Commitment, Contract, Process, Group — and their type hierarchies).
- `store/` — central event store and message router (WebSocket server on port 8081).
- `studio/` — the application: `back/` (Haskell, serves the SPA and relays browser ↔ store on port 8080) and `front/` (Elm SPA doing event sourcing in the browser via IndexedDB).
- `ident/` — identifier sequence generator. `dumb/` — placeholder processor.

Everything is JSON over WebSockets. Three levels of event sourcing: IndexedDB in the browser, one append-only JSON-lines file per service, and the store's file as the global source of truth.

## Build and run

Requires GHC 9.12.4 and Elm 0.19.2.

```bash
./build.sh              # build everything into build/
studio/rundev.sh        # build front + back, run the app on http://localhost:8080
store/rundev.sh         # run the central store on :8081
ident/rundev.sh         # run the identifier service
dumb/rundev.sh          # run the placeholder processor
./build.docker.sh       # build the Docker image
./run.compose.sh        # run the full stack with docker compose
```

## License

Apache-2.0.
