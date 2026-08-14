# Atlassian CLI (acli)
> tickets Jira uniquement

## Auth
```sh
acli jira auth login --web                                                    # OAuth browser login
acli jira auth status
```

## Recherche
```sh
acli jira workitem search --jql "project = TEAM"
acli jira workitem search --jql "assignee = currentUser() AND status != Done"
acli jira workitem search --jql "project = TEAM AND status = 'In Progress'" --fields "key,summary,status"
```

## Créer / consulter / éditer
```sh
acli jira workitem create --summary "New Task" --project "TEAM" --type "Task"
acli jira workitem view TEAM-123
acli jira workitem edit TEAM-123 --summary "Updated summary"
```

## Transition & commentaires
```sh
acli jira workitem transition --key TEAM-123 --status "In Progress"           # --key, pas positionnel
acli jira workitem comment create --key TEAM-123 --body "some comment"
acli jira workitem comment list --key TEAM-123
```

## Raccourcis (.zshrc.d/core/50_acli.zsh)
```sh
jira <cmd>                                                                    # wrapper sur `acli jira`
jira-mine                                                                     # mes tickets non terminés
jira-view TEAM-123                                                            # voir un ticket
jira-open TEAM-123                                                            # ouvrir dans le navigateur
jira-comment TEAM-123 "some comment"                                          # commenter
jira-move TEAM-123 "In Progress"                                              # transitionner
```
`jira-<TAB>` liste les raccourcis. TAB sur l'argument de `jira-view`/`-open`/`-comment`/`-move`
complète mes tickets ouverts (un appel Jira par TAB, acli n'a pas de cache).

## TUI
```sh
fjira                                                                         # navigation fuzzy, auth séparée d'acli
```

## Help
```sh
acli jira workitem <sous-commande> -h
```
