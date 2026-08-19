# Codex App Factory

A small, subscription-first harness for building personal applications with Codex.

The factory turns reviewed GitHub issues into tested draft pull requests. Codex may plan, implement, test, repair, document, push a branch, and open a pull request. The owner remains the production gate: the factory never merges a pull request or performs a destructive or paid action without explicit approval.

## The team

- **Orchestrator:** the primary Codex agent. Owns workflow state, delegation, retries, Git, and the final report.
- **Product Manager:** checks that a feature is buildable, appropriately scoped, and has an observable definition of done.
- **Builder:** implements one approved ticket and runs focused checks.
- **QA:** independently reviews the change, runs tests, and reports concrete failures. QA does not edit code.

## State model

GitHub issues are the durable queue.

| Label | Meaning |
| --- | --- |
| `factory:ready` | Reviewed and available for a run |
| `factory:building` | Claimed by a run |
| `factory:review` | Draft PR is ready for the owner |
| `factory:blocked` | A concise owner decision is required |

One scheduled run handles at most one ticket. A run exits before loading the full repository when nothing is ready.

## Create a new app

```sh
./scripts/new-app.sh /absolute/path/to/new-app
```

The command copies the factory instructions, custom agents, skill, issue form, CI workflow, and product documents. It does not create accounts, a GitHub repository, or a deployment.

After the product brief and initial issues exist, configure a Codex desktop scheduled task using `factory/AUTOMATION-PROMPT.md` from the app repository. Start with manual runs until the smoke ticket has completed end to end.

## Operating boundary

This repository and all apps created from it are independent from `/Users/keshav/Projects/app-factory` and `/Users/keshav/Projects/fpl-advisor`. Do not copy state, modify those repositories, or share their automations.
