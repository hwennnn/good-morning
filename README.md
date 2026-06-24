# Good Morning

A tiny GitHub Actions workflow that starts a daily AI-agent check-in every morning at 9am Pacific time.

Pick Codex or Claude, say good morning, inspect the repository, and open a GitHub issue with a short summary of anything worth noticing that day.

## What It Does

Every morning, the workflow:

- Runs either Codex or Claude through their native GitHub Actions.
- Prompts the selected agent with a lightweight daily check-in.
- Prevents the agent from modifying files.
- Creates a GitHub issue containing the selected agent's response.

The prompt asks the selected agent to return:

- A short good-morning greeting.
- Anything important to look at today.
- Obvious broken tests, stale TODOs, risky open work, or maintenance tasks.
- One suggested next action.

## Setup

Add the secret for the agent you want to use:

1. Open the GitHub repository.
2. Go to `Settings` -> `Secrets and variables` -> `Actions`.
3. Add `OPENAI_API_KEY` for Codex.
4. Add `ANTHROPIC_API_KEY` for Claude.

For scheduled runs, set an optional repository variable named `MORNING_AGENT`:

- `codex`
- `claude`

If `MORNING_AGENT` is not set, scheduled runs use `codex`.

## Schedule

GitHub Actions schedules use UTC, so the workflow defines two cron entries:

- `0 16 * * *` for 9am Pacific daylight time.
- `0 17 * * *` for 9am Pacific standard time.

The job then checks `America/Los_Angeles` inside the runner and only continues when the local Pacific hour is `09`. This keeps the workflow aligned with daylight saving time changes.

## Manual Runs

The workflow supports `workflow_dispatch`, so you can run it manually from the GitHub Actions tab at any time.

Manual runs let you choose:

- `codex`
- `claude`

You can also pass an optional extra instruction for that run. Manual runs skip the 9am gate and execute immediately.

## Permissions

The workflow requests:

- `contents: read` so the selected agent can inspect the repository.
- `issues: write` so the workflow can open the daily check-in issue.

The selected agent is prompted not to edit files. If you want the agent to make changes later, update the prompt and permissions deliberately.

## Customizing

Edit `.github/prompts/morning-check-in.md` to change the shared morning prompt.

Edit `.github/workflows/good-morning.yml` to change:

- Agent routing.
- The issue title.
- The schedule.
- Whether the agent reports only or makes changes.

Keep secret and variable names in sync with the workflow if you rename them.
