#!/usr/bin/env zsh

# slackcli ships no `completion` subcommand and no static _slackcli file
# (commander.js CLI, no completion generator) — hand-rolled top-level only.
_slackcli() {
  local -a subcommands
  subcommands=(
    'auth:manage authentication'
    'conversations:list/read channels and DMs'
    'messages:send/edit/react to messages'
    'canvas:list/read canvases'
    'update:check/apply updates'
  )
  _describe 'command' subcommands
}
compdef _slackcli slackcli

# reads a conversation/thread from a Slack link — either a permalink
# (…/archives/<C…>/p<ts>[?thread_ts=…]) or a plain channel link (app.slack.com/client/<T…>/<C…>);
# falls back to a plain channel read when no message ts is present in the URL
slurl() {
  local url="$1" channel ts thread_ts
  channel=$(echo "$url" | grep -oE '\b[CGD][A-Z0-9]{8,}\b' | head -1)
  thread_ts=$(echo "$url" | grep -oE 'thread_ts=[0-9]+\.[0-9]+' | cut -d= -f2)
  if [[ -z "$thread_ts" ]]; then
    ts=$(echo "$url" | grep -oE '/p[0-9]+' | tr -d '/p')
    [[ -n "$ts" ]] && thread_ts="${ts[1,-7]}.${ts[-6,-1]}"
  fi
  if [[ -n "$thread_ts" ]]; then
    slackcli conversations read "$channel" --thread-ts="$thread_ts" "${@:2}"
  else
    slackcli conversations read "$channel" "${@:2}"
  fi
}
