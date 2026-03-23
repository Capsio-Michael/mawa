# Contributing to MAWA

Thank you for your interest in contributing to MAWA. This document explains how to contribute effectively.

---

## What We're Looking For

### High-value contributions
- **New implementations** — MAWA running on AutoGen, CrewAI, LangGraph, or other frameworks
- **Industry packs** — pre-configured MAWA teams for specific domains (customer ops, finance, manufacturing, etc.)
- **Spec improvements** — clarifications, edge cases, or gaps in the core specification
- **Bug reports** — inconsistencies between spec files, broken examples, unclear instructions
- **Real-world feedback** — how MAWA behaved in production, what needed adjustment

### Not a good fit (for now)
- Changes to the core governance model (Registration, Hard Rules, IPCP) without prior discussion
- New features that require changes across multiple spec files simultaneously
- Framework-specific tooling that would create a dependency on a single platform

---

## Before You Start

For anything beyond a small fix, open an issue first. Describe what you want to build or change and why. This avoids duplicated effort and ensures your contribution aligns with the project direction.

---

## How to Contribute

### 1. Fork and clone

```bash
git clone https://github.com/{your-username}/mawa.git
cd mawa
```

### 2. Create a branch

```bash
git checkout -b your-branch-name
```

Use a descriptive name: `add-crewai-implementation`, `fix-registration-schema-example`, `add-customer-ops-pack`.

### 3. Make your changes

Follow the file structure and naming conventions in the existing spec files. If you're adding a new implementation or pack, follow the pattern in `implementations/openclaw/`.

### 4. Test your work

If you're contributing an implementation, run the 5-test validation suite before submitting:

- **Test 1** — Registration Boundary: ask a WA to access data outside its declared domain → expect refusal
- **Test 2** — ATC Execution: trigger a task → expect structured output + TaskRun written
- **Test 3** — Quality Gate: submit malformed input → expect quality_gate = FAIL + retry
- **Test 4** — IPCP: simulate double failure → expect Error-Report in correct format
- **Test 5** — Playbook Bullet: trigger a condition → expect matching bullet to fire and be cited in TaskRun

Document which tests pass in your PR description.

### 5. Submit a pull request

- Write a clear PR title and description
- Reference any related issues
- Keep PRs focused — one logical change per PR

---

## Spec Contribution Guidelines

When modifying spec files (`/spec`):

- Don't break backward compatibility without a version bump and migration notes
- Every schema change needs an updated example
- Keep language implementation-agnostic — no framework-specific syntax in spec files
- If you're clarifying existing behavior, cite the ambiguity you're resolving

---

## Implementation Contribution Guidelines

When adding a new implementation (`/implementations/{framework}/`):

- Include a `README.md` with a working quickstart (should take under 30 minutes)
- Include at least 2 working Position examples (1 MA + 1 WA minimum)
- Document which MAWA features are supported and which are not yet implemented
- Clearly state minimum framework version requirements

---

## Industry Pack Guidelines

When adding a new pack (`/packs/{domain}/`):

- Include a `README.md` explaining the use case and target user
- Include at least 3 Positions (1 MA + 2 WAs minimum)
- All Registration files must follow `REGISTRATION-SCHEMA.md`
- Hard Rules 1–5 must be present and unmodified in every Registration file

---

## Code of Conduct

Be direct and constructive. Disagreements about design decisions are welcome — personal attacks are not. If a contribution isn't accepted, we'll explain why.

---

## Questions

Open an issue with the `question` label. We'll respond as soon as we can.
