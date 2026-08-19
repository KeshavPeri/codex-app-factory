# Operating guide

## Start a new app

1. Choose the generic template or a justified technology profile.
2. Run `scripts/new-app.sh` with an empty target directory and optional profile name.
3. Complete `docs/product-brief.md` from the design workshop.
4. Record owner decisions and let future factory runs add material delegated Product Manager decisions to `docs/decisions.md`.
5. Fill `factory/PROJECT-CONFIG.md` with the app's real setup, verification, QA, and deployment commands.
6. Create the app baseline, GitHub repository, workflow labels, CI, and owner-reviewed deployment.
7. Create small GitHub issues with observable acceptance criteria.
8. Run one trivial smoke ticket manually through `$codex-app-factory`.
9. Only after that succeeds, create a scheduled Codex task using `factory/AUTOMATION-PROMPT.md`.

## Normal review loop

When a draft PR appears:

1. Read the outcome and risk sections of the review packet.
2. Check that CI passed.
3. Exercise the user-facing change, using the supplied preview or local QA evidence.
4. Merge only when you can explain what changed and what was verified.
5. If something is wrong, comment with the observed behavior and return the issue to `factory:ready` after the ticket is clarified.

## Failure playbook

- **Nothing ran:** confirm the computer was awake, Codex was running, and the scheduled task still targets the correct local project.
- **Ticket is blocked:** read the named authority boundary or dependency, answer the single question or resolve the external prerequisite, update the specification if needed, and change the label back to `factory:ready`.
- **Run died while building:** keep the branch. The next run should recover it by issue number instead of starting a second branch.
- **Tests repeatedly fail:** after two builder revisions, split or rewrite the ticket. Do not invite endless agent loops.
- **Usage is unexpectedly high:** reduce schedule frequency, keep one ticket per run, and reserve subagents for the defined product/build/QA gates.
- **No preview exists:** use the local test evidence in the PR. Preview infrastructure is optional; invented URLs are not.

## Owner-only actions

The Product Manager is expected to decide routine product questions from the approved objective and feature list, document its reasoning, and keep the run moving. It should prefer the simplest reversible option when uncertainty is low risk.

The factory must stop for production merges, account creation, billing changes, new secrets, destructive or irreversible data operations, public exposure of private information, or a decision that materially changes the app's fundamental purpose, intended users, approved scope, committed deadline, privacy boundary, cost, infrastructure commitment, or another explicit owner constraint.
