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
acli jira workitem transition TEAM-123 --status "In Progress"
acli jira workitem comment-create TEAM-123 --body "some comment"
acli jira workitem comment-list TEAM-123
```

## Help
```sh
acli jira workitem <sous-commande> -h
```
