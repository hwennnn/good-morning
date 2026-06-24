# Good Morning

A tiny GitHub Actions workflow that starts a daily Codex check-in every morning at 9am Pacific time.

Codex says good morning, inspects the repository, and opens a GitHub issue with a short summary of anything worth noticing that day.

## What It Does

Every morning, the workflow:

- Runs Codex through the official `openai/codex-action@v1` GitHub Action.
- Prompts Codex with a lightweight daily check-in.
- Prevents Codex from modifying files.
- Creates a GitHub issue containing Codex's response.

The prompt asks Codex to return:

- A short good-morning greeting.
- Anything important to look at today.
- Obvious broken tests, stale TODOs, risky open work, or maintenance tasks.
- One suggested next action.

## Setup

Add an OpenAI API key as a GitHub Actions secret:

1. Open the GitHub repository.
2. Go to `Settings` -> `Secrets and variables` -> `Actions`.
3. Create a new repository secret named `OPENAI_API_KEY`.
4. Paste your OpenAI API key as the value.

That is the only required setup.

## Schedule

GitHub Actions schedules use UTC, so the workflow defines two cron entries:

- `0 16 * * *` for 9am Pacific daylight time.
- `0 17 * * *` for 9am Pacific standard time.

The job then checks `America/Los_Angeles` inside the runner and only continues when the local Pacific hour is `09`. This keeps the workflow aligned with daylight saving time changes.

## Manual Runs

The workflow also supports `workflow_dispatch`, so you can run it manually from the GitHub Actions tab at any time.

Manual runs skip the 9am gate and execute immediately.

## Permissions

The workflow requests:

- `contents: read` so Codex can inspect the repository.
- `issues: write` so the workflow can open the daily check-in issue.

Codex is prompted not to edit files. If you want Codex to make changes later, update the prompt and permissions deliberately.

## Customizing

Edit `.github/workflows/codex-morning.yml` to change:

- The morning prompt.
- The issue title.
- The schedule.
- Whether Codex reports only or makes changes.

Keep the `OPENAI_API_KEY` secret name in sync with the workflow if you rename it.
