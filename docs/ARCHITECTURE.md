# Architecture

## Control flow

```text
GitHub issue: factory:ready
          |
          v
Primary Codex agent (orchestrator)
          |
          +--> Product Manager (read-only gate)
          |
          +--> Builder (single writer)
          |
          +--> QA (read-only independent gate)
          |
          v
Draft pull request + CI evidence
          |
          v
Owner reviews and merges
          |
          v
Deterministic production deployment
```

The primary agent owns labels, branches, commits, pushes, and pull requests. This prevents role agents from racing over shared state. Only one code-writing agent runs at a time. Product and QA work remain independent and read-only.

## Durable state

The system is deliberately stateless between runs:

- GitHub issue labels express queue state.
- The issue records questions and owner decisions.
- A feature branch preserves partial implementation.
- A draft PR contains the review packet and CI history.
- `docs/decisions.md` records expensive-to-reverse decisions.

A new Codex session can reconstruct the situation from those artifacts.

## Deployment

The default app template targets a static Vite-compatible build deployed to GitHub Pages after a merge to `main`. Pull requests run CI but do not deploy production. Projects with different infrastructure should replace the Pages workflow deliberately and record the decision in the product brief.

## Subscription boundary

The local harness is intended to run through Codex signed in with ChatGPT. It does not configure an OpenAI API key. Local scheduled work requires the Codex desktop app and computer to remain available. Any migration to an always-on API-backed runner is a separate architecture and billing decision.
