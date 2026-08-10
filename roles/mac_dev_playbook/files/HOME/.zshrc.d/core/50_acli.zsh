#!/usr/bin/env zsh

source <(acli completion zsh)

alias jira="acli jira"
alias jme='acli jira workitem search --jql "assignee = currentUser() AND status != Done"'

function jv() { acli jira workitem view "$1"; }
function jc() { acli jira workitem comment-create "$1" --body "$2"; }
