# Good Morning

A tiny GitHub Actions workflow that says:

```text
Good morning
```

It runs every day at 9am Pacific time. You can also run it manually from the GitHub Actions tab.

## Schedule

GitHub Actions uses UTC for cron, so the workflow schedules both Pacific offsets:

- `0 16 * * *` for 9am Pacific daylight time.
- `0 17 * * *` for 9am Pacific standard time.

The job checks `America/Los_Angeles` before printing, so only the actual 9am Pacific run says good morning.
