#!/usr/bin/env zsh

zmodload zsh/datetime
zmodload zsh/stat

source <(acli completion zsh)

# Shared by `jira-mine` and the key completion below.
_acli_my_jql='assignee = currentUser() AND status != Done'

jira() { acli jira "$@"; }
jira-mine() { acli jira workitem search --jql "$_acli_my_jql" "$@"; }
jira-view() { acli jira workitem view "$1"; }
jira-comment() { acli jira workitem comment create --key "$1" --body "$2"; }
jira-move() { acli jira workitem transition --key "$1" --status "$2"; }

# My open work items, cached 5min -- one Jira round-trip per TAB is too slow,
# and acli has no cache of its own. A failed/unauthenticated fetch caches
# empty, so it doesn't retry on every TAB.
_acli_workitem_keys() {
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/acli-workitem-keys
  local -a items

  if [[ ! -f $cache ]] || (( EPOCHSECONDS - $(zstat +mtime $cache) > 300 )); then
    mkdir -p ${cache:h}
    acli jira workitem search --jql "$_acli_my_jql" \
      --csv --fields key,summary >| $cache 2>/dev/null
  fi

  # Drop the CSV header row, then "KEY-1,summary" -> the "KEY-1:summary" _describe expects.
  items=( ${${(f)"$(<$cache)"}[2,-1]/,/:} )
  _describe -t workitems 'work item' items
}

# Key only on the first argument; body/status after it are free text.
_acli_key_arg() { (( CURRENT == 2 )) && _acli_workitem_keys; }
compdef _acli_key_arg jira-view jira-comment jira-move

# Reuse acli's own completion for `jira`: its cobra script shells out to
# ${words[1]} __complete, so words[1] has to be the real binary, not `jira`.
_jira() {
  words=(acli jira "${(@)words[2,-1]}")
  (( CURRENT++ ))
  _acli
}
compdef _jira jira
