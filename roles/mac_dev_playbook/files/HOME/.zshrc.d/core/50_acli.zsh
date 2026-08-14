#!/usr/bin/env zsh

source <(acli completion zsh)

# Shared by `jira-mine` and the key completion below.
_acli_my_jql='assignee = currentUser() AND status != Done'

jira() { acli jira "$@"; }
jira-mine() { acli jira workitem search --jql "$_acli_my_jql" "$@"; }
jira-view() { acli jira workitem view "$1"; }
jira-open() { acli jira workitem view "$1" --web; }
jira-comment() { acli jira workitem comment create --key "$1" --body "$2"; }
jira-move() { acli jira workitem transition --key "$1" --status "$2"; }

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
compdef _acli_key_arg jira-view jira-open jira-comment jira-move

# Reuse acli's own completion for `jira`: its cobra script shells out to
# ${words[1]} __complete, so words[1] has to be the real binary, not `jira`.
_jira() {
  words=(acli jira "${(@)words[2,-1]}")
  (( CURRENT++ ))
  _acli
}
compdef _jira jira
