# Good Morning

A tiny GitHub Actions workflow that wakes Codex, Claude, or both every morning with one prompt:

```text
Good morning
```

No repo analysis, no issue creation, no extra instructions.

## Setup

The workflow can run in three modes:

- `codex`
- `claude`
- `both`

Add the matching GitHub secret on the repo's [Actions secrets page](https://github.com/hwennnn/good-morning/settings/secrets/actions):

| Agent | Secret name | Where to create the key |
| --- | --- | --- |
| Codex | `OPENAI_API_KEY` | [OpenAI API keys](https://platform.openai.com/api-keys) |
| Claude | `ANTHROPIC_API_KEY` | [Anthropic Console keys](https://console.anthropic.com/settings/keys) |

To add a secret: create/copy the API key, click `New repository secret`, use the exact secret name above, paste the key as the value, and save.

Secrets are only for API keys. The manual workflow popup will not show or ask for these secrets; GitHub reads them privately when the workflow runs.

## Choosing The Agent

There are two ways to choose the agent.

### Manual Runs

Manual runs use the dropdown on the [workflow page](https://github.com/hwennnn/good-morning/actions/workflows/good-morning.yml). Pick:

- `codex`
- `claude`
- `both`

This dropdown is not a secret field. It only chooses which agent action to run.

### Scheduled Runs

Scheduled runs read `MORNING_AGENT` from **Repository variables** on the repo's [Actions variables page](https://github.com/hwennnn/good-morning/settings/variables/actions).

Use **Repository variables**, not **Environment variables**.

Set `MORNING_AGENT` to:

- `codex`
- `claude`
- `both`

If the variable is not set, the workflow defaults to `codex`.

## Schedule

The workflow runs at 9am Pacific. GitHub cron uses UTC, so it schedules both Pacific offsets:

- `0 16 * * *` for daylight time.
- `0 17 * * *` for standard time.

The job checks `America/Los_Angeles` before greeting the agent, so only the real 9am Pacific run activates it.
