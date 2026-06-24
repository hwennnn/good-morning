#!/usr/bin/env bash
set -euo pipefail

TZ_NAME="${TZ_NAME:-America/Los_Angeles}"
PROMPT="${PROMPT:-Good morning.}"
WORKDIR="${WORKDIR:-$HOME}"
STATE_DIR="${STATE_DIR:-$HOME/.local/state/good-morning-codex}"
PID_FILE="$STATE_DIR/pid"
LOG_FILE="$STATE_DIR/run.log"
LAST_FILE="$STATE_DIR/last-message.txt"

next_run_epoch() {
  local now today
  now="$(TZ="$TZ_NAME" date +%s)"
  today="$(TZ="$TZ_NAME" date -d "today 09:00" +%s)"
  if [ "$now" -lt "$today" ]; then
    printf '%s\n' "$today"
  else
    TZ="$TZ_NAME" date -d "tomorrow 09:00" +%s
  fi
}

run_codex() {
  mkdir -p "$STATE_DIR"
  {
    printf '\n[%s] running\n' "$(TZ="$TZ_NAME" date '+%F %T %Z')"
    if [ "${RESUME_LAST:-0}" = "1" ]; then
      codex exec resume --last --skip-git-repo-check -o "$LAST_FILE" "$PROMPT"
    else
      codex exec --skip-git-repo-check -C "$WORKDIR" -o "$LAST_FILE" "$PROMPT"
    fi
    printf '[%s] done\n' "$(TZ="$TZ_NAME" date '+%F %T %Z')"
  } >>"$LOG_FILE" 2>&1
}

loop() {
  mkdir -p "$STATE_DIR"
  echo "$$" >"$PID_FILE"
  trap 'rm -f "$PID_FILE"; exit' INT TERM EXIT

  while :; do
    next="$(next_run_epoch)"
    now="$(date +%s)"
    sleep_for=$(( next - now ))
    [ "$sleep_for" -gt 0 ] && sleep "$sleep_for"
    run_codex
  done
}

start() {
  mkdir -p "$STATE_DIR"
  if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "already running: pid $(cat "$PID_FILE")"
    exit 0
  fi
  nohup "$0" loop >/dev/null 2>&1 &
  echo "started: pid $!"
  echo "log: $LOG_FILE"
}

stop() {
  if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    kill "$(cat "$PID_FILE")"
    echo "stopped"
  else
    echo "not running"
  fi
}

status() {
  if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "running: pid $(cat "$PID_FILE")"
  else
    echo "not running"
  fi
  echo "next: $(TZ="$TZ_NAME" date -d "@$(next_run_epoch)" '+%F %T %Z')"
  echo "log: $LOG_FILE"
}

case "${1:-start}" in
  start) start ;;
  stop) stop ;;
  status) status ;;
  run-now) run_codex ;;
  loop) loop ;;
  *) echo "usage: $0 [start|stop|status|run-now]" >&2; exit 2 ;;
esac
