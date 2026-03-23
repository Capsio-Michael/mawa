# Changelog

All notable changes to MAWA will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [0.1.0] — 2026-03-23

### Added

**Core Specification (`/spec`)**
- `MAWA-SPEC.md` — full architecture specification (Position, Registration, ATC, Playbook, IPCP, TaskRun, Dispatcher, Reflector, Curator)
- `REGISTRATION-SCHEMA.md` — capability declaration standard with full schema, field reference, and working example
- `ATC-SCHEMA.md` — task card format with W-H-A-T structure, quality gate rules, and TaskRun requirements
- `PLAYBOOK-SCHEMA.md` — strategy bullet format, lifecycle (PILOT→SOTA→LEGACY), and effectiveness tracking
- `IPCP-PROTOCOL.md` — cross-agent communication protocol with all intent types, audit log format, and standard message flows
- `DISPATCH-TABLE-SCHEMA.md` — routing table format with priority rules and NO_MATCH handling

**Reference Implementation (`/implementations/openclaw`)**
- Complete workspace structure for 1 MA (FClaw) + 4 WAs (Booky, Michael, Pepper, Stocky)
- REGISTRATION.md and SOUL.md for all 5 positions
- ATC files: 8 task cards covering daily summary, quality evaluation, stock broadcast, personal assistance, and MA routing
- WHAT files: 2 position context documents
- PLAYBOOK files: 4 strategy documents (v1 PILOT) with execution, risk, and quality bullets
- 4 SKILL files: Dispatcher, Reflector, Curator, Audit
- `MAWA_DISPATCH_TABLE.md` — routing index for all 4 WAs
- `setup.sh` — one-command workspace bootstrap
- `README.md` — quickstart guide with 5-step setup

**Validation**
- 5-test validation suite covering: Registration Boundary, ATC Execution, Quality Gate, IPCP Protocol, Playbook Bullet

**Community**
- `CONTRIBUTING.md` — contribution guidelines for implementations, packs, and spec improvements
- `packs/README.md` — industry pack directory (4 packs planned)

### Notes
- v0.1.0 is the initial public release
- All spec files are v1.0
- OpenClaw is the only supported implementation at launch
- Industry packs (customer-ops, trading, manufacturing) are planned for v0.2.0
