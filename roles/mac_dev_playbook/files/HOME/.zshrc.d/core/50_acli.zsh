#!/usr/bin/env zsh

source <(acli completion zsh)

# Shared by `jira-mine` and the key completion below.
_acli_my_jql='assignee = currentUser() AND status != Done'

jira() { acli jira "$@"; }
jira-mine() { acli jira workitem search --jql "$_acli_my_jql" "$@" | jira-linkify; }
jira-view() { acli jira workitem view "$1"; }
jira-open() { acli jira workitem view "$1" --web; }
jira-comment() { acli jira workitem comment create --key "$1" --body "$2"; }
jira-move() { acli jira workitem transition --key "$1" --status "$2"; }

# Jira site host, resolved once per shell from acli's own auth state --
# avoids hardcoding a Jira instance URL in this public dotfiles repo.
_jira_site() { acli jira auth status 2>/dev/null | awk '/Site:/{print $2}'; }

# jira-web INFC-1859 -- open a ticket directly by URL, no acli API round trip.
jira-web() {
  local site="$(_jira_site)"
  if [[ -z "$site" ]]; then
    echo "acli not authenticated: run 'acli jira auth login --web'" >&2
    return 1
  fi
  local url="https://$site/browse/$1"
  if [[ "$(uname)" == "Darwin" ]]; then
    open "$url"
  else
    xdg-open "$url"
  fi
}

# Make ticket keys in piped output clickable via OSC 8 hyperlinks, e.g.
# `git log | jira-linkify`. Ghostty renders OSC 8 links but has no built-in
# regex-to-link detection yet (https://github.com/ghostty-org/ghostty/discussions/4379).
jira-linkify() {
  local site="$(_jira_site)"
  # Skip when stdout isn't a terminal (redirected to a file, --csv/--json
  # consumed by a script, etc.) -- OSC 8 escapes would corrupt that output.
  if [[ -z "$site" ]] || [[ ! -t 1 ]]; then
    cat
    return
  fi
  perl -pe 's#\b([A-Z][A-Z0-9]+-[0-9]+)\b#"\e]8;;https://'"$site"'/browse/$1\a$1\e]8;;\a"#ge'
}

# My open work items. One Jira round-trip per TAB -- acli has no cache.
_acli_workitem_keys() {
  local -a items
  # Drop the CSV header row, then "KEY-1,summary" -> the "KEY-1:summary" _describe expects.
  items=( ${${(f)"$(acli jira workitem search --jql "$_acli_my_jql" \
    --csv --fields key,summary 2>/dev/null)"}[2,-1]/,/:} )
  _describe -t workitems 'work item' items
}

# Key only on the first argument; body/status after it are free text.
_acli_key_arg() { (( CURRENT == 2 )) && _acli_workitem_keys; }
compdef _acli_key_arg jira-view jira-open jira-web jira-comment jira-move

# Reuse acli's own completion for `jira`: its cobra script shells out to
# ${words[1]} __complete, so words[1] has to be the real binary, not `jira`.
_jira() {
  words=(acli jira "${(@)words[2,-1]}")
  (( CURRENT++ ))
  _acli
}
compdef _jira jira
