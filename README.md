# Bazalt

Bazalt is an ERP engine based on the REA ontology (Resources, Events, Agents): it models any organization by configuration alone — no business-specific code, no database. Everything is event sourcing over append-only files, with state rebuilt in memory.

## Origin

Bazalt is the AI-assisted revival, as a single monorepo, of ideas first developed by hand in the [modelyz-* repositories](https://github.com/ccomb?tab=repositories&q=modelyz). The event flow of the original design solidified here — like lava into basalt.

## How a solution is built

A client's solution has three parts, and none of them is code inside Bazalt:

1. **A configuration**: the client's own notions (a member, a kilo of mango purée, a sales contract with its payment terms) expressed with the REA ontology, as messages in the journal. An AI agent can derive it from a requirements document; a person can enter it in `studio` or from the command line.
2. **The capabilities it needs**: optional services that each add one responsibility (identifiers, balances, rules, connectors to external data), so the engine never grows bigger than the solution.
3. **An interface made for that client**, which works offline with its own event store and resynchronizes on reconnect.

The ontology, in `message/`, guarantees that neither a user nor an AI agent can write something incoherent. Design decisions and their reasons live in [`docs/`](docs/) (French).

## Architecture

- `message/` — shared Haskell library: the REA ontology (Resource, Event, Agent, Commitment, Contract, Process, Group, and their type hierarchies), its JSON codecs, and the message envelope.
- `store/` — central event store and orchestrator (WebSocket server on port 8081).
- `studio/` — the configuration tool, enough to try a solution: `back/` (Haskell, serves the SPA and relays browser ↔ store on port 8080) and `front/` (Elm SPA doing event sourcing in the browser via IndexedDB).
- `ident/` — identifier capability (invoice, contract or quote numbers). `dumb/` — default capability, answering every message no other one handles.

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
