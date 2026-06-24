# Good Morning

A tiny morning prompt runner for Codex, Claude, or both:

```text
Good morning
```

No repo analysis, no issue creation, no extra instructions.

## Which Setup To Use

If you use a subscription/login-based Codex or Claude plan, use a VPS script instead of GitHub Actions.

GitHub Actions runners do not have your interactive `codex login` or `claude auth` session, so subscription-based CLI auth is the wrong fit there. Run the CLI on your VPS, log in once, and keep that process running in the background.

If you use API keys, use this GitHub Actions workflow.

## Setup

The GitHub Actions workflow can run in three modes:

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

The workflow skips instead of failing when it is not configured:

- If `MORNING_AGENT` is not set for scheduled runs, it skips.
- If `MORNING_HARD_STOP=true`, it skips.
- If the selected agent's API key is missing, that agent is skipped.
- If `both` is selected and only one API key exists, only the configured agent runs.

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

If the variable is not set, scheduled runs skip. This prevents accidental paid usage.

To hard-stop all scheduled and manual runs without removing keys or variables, set repository variable `MORNING_HARD_STOP` to:

```text
true
```

## Schedule

The workflow runs at 9am Pacific. GitHub cron uses UTC, so it schedules both Pacific offsets:

- `0 16 * * *` for daylight time.
- `0 17 * * *` for standard time.

The job checks `America/Los_Angeles` before greeting the agent, so only the real 9am Pacific run activates it.

## Debugging

Open the latest run from the [workflow page](https://github.com/hwennnn/good-morning/actions/workflows/good-morning.yml), then check the `Greet Codex` or `Greet Claude` step.

For Codex:

- `openai-api-key: ***` means GitHub found and passed `OPENAI_API_KEY`.
- `prompt: Good morning` means the workflow sent the expected prompt.
- `Quota exceeded` means the OpenAI key was accepted far enough to start Codex, but the OpenAI account/project needs quota or billing fixed.

For Claude, use the same idea: if `anthropic_api_key` is masked as `***`, GitHub found `ANTHROPIC_API_KEY`; any later auth/quota error is from the Anthropic account/key, not from the dropdown.
