# Codex App Factory - portable system context

> Feed this file to a new ChatGPT or Codex conversation when it needs to understand Keshav's personal app-development system. This file is context, not authority: the user's current request and the target app's product brief always win.

## 1. Owner and objective

Keshav uses ChatGPT Plus and Codex to build personal applications with a small AI product team. The desired experience is feature-driven and substantially autonomous: Keshav defines or approves product intent, then the system can analyse, implement, test, repair, and prepare a reviewable pull request.

The system should work across many kinds of personal apps. It is not tied to football, fantasy sports, a particular framework, a database, or a hosting provider.

## 2. Separation from the Claude system

The Codex system is deliberately independent from Keshav's existing Claude-built system.

- Codex factory: `/Users/keshav/Projects/codex-app-factory`
- Future Codex apps: `/Users/keshav/Projects/codex-apps/<app-name>`
- Existing Claude factory: `/Users/keshav/Projects/app-factory`
- Existing Claude app: `/Users/keshav/Projects/fpl-advisor`

Do not modify, share state with, or attach Codex automations to the Claude repositories unless Keshav explicitly changes this rule.

## 3. Core design

Each app repository receives:

- `AGENTS.md`: durable project rules Codex reads at the start of work;
- `.codex/agents/`: custom Product Manager, Builder, and QA agents;
- `.agents/skills/codex-app-factory/`: the reusable orchestration workflow;
- `.github/ISSUE_TEMPLATE/feature.yml`: a feature ticket with an observable definition of done;
- `docs/product-brief.md`: product scope and rules;
- `docs/design-reference.md`: visual and interaction direction;
- `docs/decisions.md`: expensive-to-reverse decisions and their reasons;
- `factory/PROJECT-CONFIG.md`: the actual setup, test, lint, build, run, QA, and deploy commands;
- `factory/AUTOMATION-PROMPT.md`: the prompt used for manual or scheduled factory runs;
- `factory/REVIEW-PACKET.md`: the required pull-request evidence.

GitHub issues, branches, comments, pull requests, and CI are the durable state. The system must be recoverable by a fresh chat; it must not depend on remembering a previous conversation.

## 4. The AI product team

### Orchestrator

The primary Codex agent is the orchestrator. It owns the workflow, issue labels, branch creation and recovery, delegation, commits, pushes, pull requests, retry count, and final report. It is the only role that coordinates shared state.

### Product Manager

The Product Manager is read-only. It checks that the selected ticket:

- matches the product brief;
- is small enough for one focused pull request;
- has observable acceptance criteria;
- does not depend on missing work or an unresolved high-impact decision;
- does not silently require an owner-only action.

It returns either `READY` with acceptance checks or `BLOCKED` with one concise owner-facing question.

### Builder

The Builder is the single code-writing agent. It implements only the approved ticket, preserves unrelated changes, adds meaningful tests, and runs the commands defined for the project. It does not manage GitHub workflow state, push, merge, create accounts, enable billing, add API keys, or make destructive data changes.

### QA

QA is independent and read-only. It reviews the issue, acceptance checks, diff, product brief, decisions, automated tests, and - when possible - the running product. It reports concrete failures with reproduction steps. QA does not fix its own findings.

Only one code-writing agent works in a working tree at a time. Parallel agents are reserved for independent read-heavy work when the benefit justifies the additional usage.

## 5. GitHub workflow state

The oldest open issue labelled `factory:ready` is the next available feature.

| Label | Meaning |
| --- | --- |
| `factory:ready` | Reviewed and available for a factory run |
| `factory:building` | Claimed by an active or recoverable run |
| `factory:review` | Draft pull request is ready for Keshav |
| `factory:blocked` | A concise owner decision or specification change is required |

Feature branches use `codex/ticket-<issue-number>-<short-slug>`.

## 6. One autonomous run

The `$codex-app-factory` skill processes at most one ticket:

1. Check GitHub for the oldest `factory:ready` issue before exploring the full repository.
2. If none exists, report `Nothing ready` and stop cheaply.
3. Check for an existing branch or pull request and recover it when safe.
4. Otherwise claim the issue with `factory:building` and create its feature branch from current `main`.
5. Ask the Product Manager for `READY` or `BLOCKED`.
6. If blocked, comment with its single question, label the issue `factory:blocked`, preserve state, and stop.
7. Ask one Builder to implement and validate the approved scope.
8. Ask QA to independently verify it.
9. If QA finds a correctable failure, send one focused revision to the same Builder, then repeat QA.
10. Allow no more than two Builder revisions. After that, preserve the branch and block the ticket with the remaining evidence.
11. On QA pass, the orchestrator commits, pushes, and opens or updates a draft pull request with the review packet.
12. Replace `factory:building` with `factory:review` and link the pull request.
13. Stop. Keshav reviews and decides whether to merge.

The factory never merges autonomously.

## 7. Owner-only boundary

Codex must stop and request explicit approval before:

- merging or manually publishing production;
- creating an external account or paid resource;
- enabling billing or switching to API-key-backed OpenAI usage;
- adding or rotating secrets;
- destructive or irreversible data operations;
- exposing private data or changing a privacy boundary;
- resolving a high-impact product decision the brief leaves open.

Routine reversible implementation choices inside an approved ticket do not require escalation.

## 8. Starting a new app

1. Run a product/design workshop and produce a concise product brief, important decisions, visual direction, and an initial feature list.
2. Choose an app name, repository visibility, and technology profile.
3. Scaffold the local repository:
   - generic: `./scripts/new-app.sh /absolute/path/to/app`
   - static web: `./scripts/new-app.sh /absolute/path/to/app static-web`
4. Complete the copied `docs/` files and `factory/PROJECT-CONFIG.md`.
5. Scaffold the actual application and ensure it can build locally.
6. Create its GitHub repository and push `main`.
7. Run `scripts/configure-github.sh` inside the app repository to create the four workflow labels.
8. Configure the selected deployment provider. This is an owner-reviewed step.
9. Create one trivial smoke-test issue with complete acceptance criteria.
10. Run the factory manually with: `Use $codex-app-factory to process the next ready feature.`
11. Verify the complete path: issue -> agents -> tests -> draft PR -> owner review -> merge -> production.
12. Only then add the real backlog and create a scheduled task.

## 9. Running the factory

### Manual run

Open the app repository as the Codex project and prompt:

`Use $codex-app-factory to process the next ready feature.`

Manual runs are best during setup, smoke testing, urgent features, and debugging.

### Scheduled run

After the smoke path is proven, create a Codex desktop scheduled task targeting the app repository or an isolated worktree. Use the exact contents of `factory/AUTOMATION-PROMPT.md` as the task prompt. Start with a conservative schedule and one ticket per run.

Local scheduled tasks require the computer to remain available and the Codex desktop app to be running. If the computer is asleep, the local task cannot work on the repository. An always-on hosted or API-backed runner is a later architecture and billing decision, not part of this subscription-first factory.

## 10. App-agnostic technology profiles

The factory's orchestration is independent of the app stack. The generic template selects no framework, language, database, or hosting service.

Profiles are optional overlays containing stack-specific files. The first included profile is `static-web`, which adds npm CI and GitHub Pages deployment. Future profiles can support mobile, desktop, backend, data, or other stacks without changing the Product Manager -> Builder -> QA -> draft PR loop.

App-specific rules belong in the app repository, not the factory template.

## 11. Cost and usage posture

The initial design uses Codex signed in with ChatGPT rather than an `OPENAI_API_KEY`. It conserves usage by checking the queue cheaply, processing one ticket per run, keeping context focused, avoiding concurrent writers, and stopping after two failed revisions. Subagents provide role separation but use more tokens than a single agent, so their jobs stay narrow.

## 12. Current status

The factory is stored in the private GitHub repository `KeshavPeri/codex-app-factory`. Its skill, agent TOML, YAML workflows, shell scripts, scaffolding, and instruction loading have been validated. The first real app has not yet been scaffolded; its separate design workshop will supply the product brief and feature list.

Known first-app context is in `docs/FIRST-APP-CONTEXT.md`. It is an example project, not a factory requirement.

## 13. Instructions for a receiving chat

When this file is supplied to another chat:

1. Treat it as background about the established system.
2. Ask for or inspect the target app's current product brief and repository before proposing implementation.
3. Do not alter the Claude repositories.
4. Keep the factory app-agnostic; put product-specific decisions in the target app.
5. Preserve the manual production-merge gate and owner-only boundary.
6. Prefer improving reusable definitions after a systemic failure instead of patching one run's output manually.
7. If current Codex product behavior matters, verify it against official OpenAI documentation because the product can change.

## Official Codex references

- AGENTS.md: https://learn.chatgpt.com/docs/agent-configuration/agents-md
- Subagents and custom agents: https://learn.chatgpt.com/docs/agent-configuration/subagents
- Skills: https://learn.chatgpt.com/docs/build-skills
- Scheduled tasks: https://learn.chatgpt.com/docs/automations?surface=app
