# glab
> GitLab CLI officiel (gitlab-org/cli), équivalent de `gh` pour GitLab

## Auth
```sh
glab auth login                                            # interactif (gitlab.com)
glab auth login --hostname gitlab.example.com --token glpat-xxx
glab auth status
```

## Repos
```sh
glab repo clone group/project
glab repo view group/project --web
glab repo list                                             # mes projets
glab repo create mon-projet --group mon-groupe --private
```

## Merge requests
```sh
glab mr list --assignee=@me --all
glab mr create --fill --yes                                # titre/desc depuis les commits
glab mr view 42 --web
glab mr checkout 42                                        # checkout local de la MR
glab mr approve 42
glab mr merge 42 --squash --remove-source-branch
```

## CI/CD
```sh
glab ci status                                             # pipeline de la branche courante
glab ci view                                                # TUI des jobs du pipeline
glab ci trace <job-id>                                      # logs en direct
glab ci lint                                                # valide .gitlab-ci.yml
```

## Divers
```sh
glab variable set KEY value --masked
glab release create v1.0.0 --notes "..." ./dist/*
glab api /projects/:id/pipelines                            # appel API brut authentifié
```
