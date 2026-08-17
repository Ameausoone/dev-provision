#!/usr/bin/env zsh

# jira — work items from the terminal, on top of Atlassian's `acli`.
#
# Verbs live in the _jira_help registry and are resolved dynamically. Anything
# not registered is forwarded to `acli jira` unchanged, so the full CLI stays
# reachable: `jira workitem search …`, `jira project list`, `jira auth status`.

source <(acli completion zsh)

typeset -gA _jira_help
_jira_help[view]='show a work item'
_jira_help[open]='open a work item in the browser'
_jira_help[mine]='my unfinished work items'
_jira_help[comment]='add a comment to a work item'
_jira_help[move]='transition a work item to a status'
_jira_help[linkify]='make work item keys in piped output clickable'

# Shared by `jira mine` and the key completion below.
__jira_my_jql='assignee = currentUser() AND status != Done'

# ------------------------------------------------------------------------------
# Internals
# ------------------------------------------------------------------------------

# Jira site host, read from acli's own auth state -- avoids hardcoding a Jira
# instance URL in this public dotfiles repo. Memoised: `jira linkify` would
# otherwise shell out once per invocation in a pipeline.
typeset -g __jira_site_cache
__jira_site() {
  if [[ -z "$__jira_site_cache" ]]; then
    __jira_site_cache="$(acli jira auth status 2>/dev/null | awk '/Site:/{print $2}')"
  fi
  [[ -n "$__jira_site_cache" ]] || return 1
  print -r -- "$__jira_site_cache"
}

__jira_need_key() {
  [[ -n "$2" ]] && return 0
  print -u2 "jira $1: usage: jira $1 <KEY>"
  return 2
}

# ------------------------------------------------------------------------------
# Verbs
# ------------------------------------------------------------------------------

_jira_view() {
  __jira_need_key view "$1" || return
  acli jira workitem view "$@"
}

# Builds the browse URL directly instead of `acli workitem view --web`, which has
# to resolve the item through the API first. Falls back to acli when the site
# cannot be read from the auth state.
_jira_open() {
  __jira_need_key open "$1" || return

  local site
  if ! site="$(__jira_site)"; then
    acli jira workitem view "$1" --web
    return
  fi

  local url="https://${site}/browse/$1"
  if [[ "$(uname)" == "Darwin" ]]; then
    open "$url"
  else
    xdg-open "$url"
  fi
}

_jira_mine() {
  acli jira workitem search --jql "$__jira_my_jql" "$@" | _jira_linkify
}

_jira_comment() {
  __jira_need_key comment "$1" || return
  if [[ -z "$2" ]]; then
    print -u2 'jira comment: usage: jira comment <KEY> <body>'
    return 2
  fi
  acli jira workitem comment create --key "$1" --body "$2" "${@:3}"
}

_jira_move() {
  __jira_need_key move "$1" || return
  if [[ -z "$2" ]]; then
    print -u2 'jira move: usage: jira move <KEY> <status>'
    return 2
  fi
  acli jira workitem transition --key "$1" --status "$2" "${@:3}"
}

# Turns ticket keys in piped output into OSC 8 hyperlinks, e.g.
# `git log | jira linkify`. Ghostty renders OSC 8 links but has no built-in
# regex-to-link detection yet (https://github.com/ghostty-org/ghostty/discussions/4379).
_jira_linkify() {
  local site
  # Skip when stdout isn't a terminal (redirected to a file, --csv/--json
  # consumed by a script, etc.) -- OSC 8 escapes would corrupt that output.
  if [[ ! -t 1 ]] || ! site="$(__jira_site)"; then
    cat
    return
  fi
  perl -pe 's#\b([A-Z][A-Z0-9]+-[0-9]+)\b#"\e]8;;https://'"$site"'/browse/$1\a$1\e]8;;\a"#ge'
}

# ------------------------------------------------------------------------------
# Dispatcher -- registered verbs route, everything else goes to acli untouched
# ------------------------------------------------------------------------------

jira() {
  local verb="${1:-}"
  (( $# )) && shift

  if [[ -n "${_jira_help[$verb]}" ]] && (( $+functions[_jira_$verb] )); then
    "_jira_$verb" "$@"
  elif [[ -n "$verb" ]]; then
    acli jira "$verb" "$@"
  else
    acli jira            # acli prints its own help, which is the usage here
  fi
}

# ------------------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------------------

# My open work items. Cached: acli has no cache of its own, and this used to cost
# one Jira API round trip on every TAB.
__jira_keys() {
  local cache="${HOME}/.cache/jira/workitem-keys"
  local -a items

  mkdir -p "${cache:h}"

  if [[ ! -f "$cache" ]] || [[ -n "$(find "$cache" -mmin +5 2>/dev/null)" ]]; then
    local tmp="${cache}.new"
    if acli jira workitem search --jql "$__jira_my_jql" \
         --csv --fields key,summary >| "$tmp" 2>/dev/null && [[ -s "$tmp" ]]; then
      mv "$tmp" "$cache"
    else
      rm -f "$tmp"
    fi
  fi

  [[ -f "$cache" ]] || return

  # Drop the CSV header row, then "KEY-1,summary" -> the "KEY-1:summary" _describe expects.
  items=( ${${(f)"$(<$cache)"}[2,-1]/,/:} )
  _describe -t workitems 'work item' items
}

_jira() {
  local -a cmds
  local v

  if (( CURRENT == 2 )); then
    for v in ${(@ok)_jira_help}; do cmds+=( "${v}:${_jira_help[$v]}" ); done
    _describe -t commands 'jira command' cmds
  else
    case "${words[2]}" in
      view|open|comment|move)
        (( CURRENT == 3 )) && __jira_keys
        return
        ;;
      mine|linkify) return ;;
    esac
  fi

  # Not one of ours: hand over to acli's own completer. Its cobra script shells
  # out to `${words[1]} __complete`, so words[1] has to be the real binary.
  words=(acli jira "${(@)words[2,-1]}")
  (( CURRENT++ ))
  _acli
}
compdef _jira jira

# Muscle-memory shims for the pre-subcommand names. Delete once they stop firing.
alias jira-view='jira view'
alias jira-open='jira open'
alias jira-web='jira open'
alias jira-mine='jira mine'
alias jira-comment='jira comment'
alias jira-move='jira move'
alias jira-linkify='jira linkify'
