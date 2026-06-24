# Good Morning

A tiny GitHub Actions workflow that greets Codex, Claude, or both every morning.

The entire prompt is:

```text
Good morning
```

That is it. The point is just to wake up the selected agent sessions.

## Setup

The workflow supports three modes:

- `codex`
- `claude`
- `both`

Use the secrets for whichever modes you want to run.

## GitHub Secrets

Secrets are stored in the GitHub repository, not in this codebase.

Open the repository on GitHub, then go to:

```text
Settings -> Secrets and variables -> Actions -> New repository secret
```

### Codex Secret

Create an OpenAI API key from the OpenAI dashboard, then add it to GitHub:

1. Go to the OpenAI API keys page.
2. Create a new API key.
3. Copy the key.
4. In GitHub, create a new repository secret named:

```text
OPENAI_API_KEY
```

5. Paste the OpenAI API key as the secret value.
6. Save the secret.

Codex runs only when `OPENAI_API_KEY` exists.

### Claude Secret

Create an Anthropic API key from the Anthropic Console, then add it to GitHub:

1. Go to the Anthropic Console.
2. Create a new API key.
3. Copy the key.
4. In GitHub, create a new repository secret named:

```text
ANTHROPIC_API_KEY
```

5. Paste the Anthropic API key as the secret value.
6. Save the secret.

Claude runs only when `ANTHROPIC_API_KEY` exists.

## Choosing Agents

Scheduled runs use the repository variable `MORNING_AGENT` when it is set:

- `codex`
- `claude`
- `both`

If `MORNING_AGENT` is not set, the workflow uses `codex`.

To set it in GitHub:

1. Go to `Settings` -> `Secrets and variables` -> `Actions`.
2. Open the `Variables` tab.
3. Click `New repository variable`.
4. Name it:

```text
MORNING_AGENT
```

5. Set the value to `codex`, `claude`, or `both`.
6. Save the variable.

## Schedule

GitHub Actions uses UTC for cron, so the workflow schedules both Pacific offsets:

- `0 16 * * *` for 9am Pacific daylight time.
- `0 17 * * *` for 9am Pacific standard time.

The job checks `America/Los_Angeles` before greeting the agent, so only the actual 9am Pacific run activates it.

You can also run it manually from the GitHub Actions tab and choose `codex`, `claude`, or `both`.
