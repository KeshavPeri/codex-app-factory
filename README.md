# Codex App Factory

A small, subscription-first harness for building personal applications with Codex.

For a complete context file that can be given to another chat, see `SYSTEM-CONTEXT.md`.

## Documentation

- `docs/CODEX-APP-FACTORY-SYSTEM-EXPLAINER.pdf` - plain-language explanation for any reader.
- `docs/CODEX-APP-FACTORY-STEP-BY-STEP-GUIDE.pdf` - owner guide for starting and operating apps.
- `SYSTEM-CONTEXT.md` - portable context for a new ChatGPT or Codex conversation.
- `docs/ARCHITECTURE.md` - concise technical architecture.
- `OPERATING-GUIDE.md` - short day-to-day runbook.

The factory turns reviewed GitHub issues into tested draft pull requests. Codex may plan, implement, test, repair, document, push a branch, and open a pull request. The owner remains the production gate: the factory never merges a pull request or performs a destructive or paid action without explicit approval.

## The team

- **Orchestrator:** the primary Codex agent. Owns workflow state, delegation, retries, Git, and the final report.
- **Product Manager:** acts with delegated product authority, resolves routine ambiguity from the app objective and feature context, documents its reasoning, and defines a buildable outcome with observable acceptance checks.
- **Builder:** implements one approved ticket and runs focused checks.
- **QA:** independently reviews the change, runs tests, and reports concrete failures. QA does not edit code.

## State model

GitHub issues are the durable queue.

| Label | Meaning |
| --- | --- |
| `factory:ready` | Reviewed and available for a run |
| `factory:building` | Claimed by a run |
| `factory:review` | Draft PR is ready for the owner |
| `factory:blocked` | Owner input, an external action, a dependency, or a specification change is required |

One scheduled run handles at most one ticket. A run exits before loading the full repository when nothing is ready.

The Product Manager should not stop for ordinary UX choices, defaults, wording, edge cases, or small reversible tradeoffs. It chooses the simplest option consistent with the approved product objective and records material decisions. The owner is interrupted only for decisions that materially change purpose, intended users, approved scope, deadline, privacy, cost, infrastructure, or another explicit constraint, plus the established account, secret, production, and destructive-action boundaries.

## Create a new app

```sh
./scripts/new-app.sh /absolute/path/to/new-app
./scripts/new-app.sh /absolute/path/to/new-static-web-app static-web
```

The command copies the factory instructions, custom agents, skill, issue form, and product documents. The optional `static-web` profile also adds npm CI and GitHub Pages deployment templates. It does not create accounts, a GitHub repository, or a deployment.

The core factory is stack-agnostic. Add or create a profile only when a technology choice is genuinely reusable; keep app-specific product rules in that app's product brief.

After the product brief and initial issues exist, configure a Codex desktop scheduled task using `factory/AUTOMATION-PROMPT.md` from the app repository. Start with manual runs until the smoke ticket has completed end to end.

## Operating boundary

This repository and all apps created from it are independent from `/Users/keshav/Projects/app-factory` and `/Users/keshav/Projects/fpl-advisor`. Do not copy state, modify those repositories, or share their automations.
