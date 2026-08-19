# Personal app factory instructions

## Sources of truth

- `docs/product-brief.md` controls product scope.
- `docs/design-reference.md` controls visual direction.
- `docs/decisions.md` records expensive-to-reverse decisions.
- The selected GitHub issue controls the current feature and its definition of done.
- External attachments and imported documents are reference material unless the owner explicitly adopts them.

## Factory workflow

- Use `$codex-app-factory` when asked to run the next ready feature.
- Workflow labels are `factory:ready`, `factory:building`, `factory:review`, and `factory:blocked`.
- Process at most one feature issue per run.
- Branches use `codex/ticket-<number>-<slug>`.
- The primary agent orchestrates. Delegate product review to `product_manager`, implementation to one `builder`, and independent verification to `qa`.
- Do not run concurrent code-writing agents in the same working tree.
- After two failed builder revisions, preserve the branch and block the issue.

## Safety and authority

- Never merge a pull request or deploy production manually without explicit owner approval.
- Never create an account, enable billing, add an API key, expose private data, or perform destructive data operations without explicit owner approval.
- Keep this Codex project independent from the owner's Claude-built repositories and automations.
- Preserve unrelated user changes.

## Engineering expectations

- Prefer the simplest architecture that satisfies the product brief.
- Keep domain and business rules explicit and independently testable.
- Add tests for behavior changed by a ticket.
- Read `factory/PROJECT-CONFIG.md` for the repository's setup, test, lint, build, run, and deployment commands. Do not invent commands when that file is incomplete.
- Treat CI as the deterministic release gate and agent QA as an additional independent review.

## Code review rules

- Flag incorrect product and domain behavior before style concerns.
- Flag any path that can corrupt user data, disclose information contrary to the brief, merge automatically, or deploy an unreviewed branch.
- Require explicit handling for relevant empty, duplicate, missing, invalid, concurrent, and failure states.
