# Atlassian CLI (acli)
> tickets Jira uniquement

## Auth
```sh
acli jira auth login --web
acli jira auth status
```

## Recherche & CRUD
```sh
acli jira workitem search --jql "assignee = currentUser() AND status != Done"
acli jira workitem view TEAM-123
acli jira workitem create --summary "New Task" --project "TEAM" --type "Task"
acli jira workitem transition --key TEAM-123 --status "In Progress"
acli jira workitem comment create --key TEAM-123 --body "some comment"
```

## Raccourcis (.zshrc.d/core/50_acli.zsh)
```sh
jira-mine                                                                     # mes tickets non terminés
jira-view TEAM-123
jira-open TEAM-123                                                            # ouvrir dans le navigateur
jira-comment TEAM-123 "some comment"
jira-move TEAM-123 "In Progress"
```

## TUI
```sh
fjira                                                                         # navigation fuzzy, auth séparée d'acli
```
