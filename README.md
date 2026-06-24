# Good Morning

A tiny GitHub Actions workflow that greets Codex or Claude every morning.

The entire prompt is:

```text
Good morning
```

That is it. The point is just to wake up the selected agent/session.

## Setup

Add the secret for whichever agent you want to use:

- `OPENAI_API_KEY` for Codex.
- `ANTHROPIC_API_KEY` for Claude.

Scheduled runs use the repository variable `MORNING_AGENT` when it is set:

- `codex`
- `claude`

If `MORNING_AGENT` is not set, the workflow uses `codex`.

## Schedule

GitHub Actions uses UTC for cron, so the workflow schedules both Pacific offsets:

- `0 16 * * *` for 9am Pacific daylight time.
- `0 17 * * *` for 9am Pacific standard time.

The job checks `America/Los_Angeles` before greeting the agent, so only the actual 9am Pacific run activates it.

You can also run it manually from the GitHub Actions tab and choose `codex` or `claude`.
