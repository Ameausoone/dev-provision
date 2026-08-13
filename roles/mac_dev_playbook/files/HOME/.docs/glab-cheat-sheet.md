# glab
> GitLab CLI officiel (gitlab-org/cli), équivalent de `gh` pour GitLab

## Auth
```sh
glab auth login                                            # interactif (gitlab.com)
glab auth login --hostname gitlab.example.com              # instance self-hosted
glab auth login --hostname gitlab.example.com --web        # OAuth via navigateur
glab auth login --hostname gitlab.example.com --device     # flow device (headless, GitLab >= 17.9)
glab auth login --hostname gitlab.example.com --token glpat-xxx --api-protocol https --git-protocol ssh
cat token.txt | glab auth login --hostname gitlab.example.com --stdin
glab auth status                                           # comptes/hosts configurés
glab auth logout --hostname gitlab.example.com
```

Le token est stocké dans le keyring de l'OS ; `--insecure-storage` le met en clair dans
`~/.config/glab-cli/config.yml`.

## Plusieurs GitLab self-hosted
```sh
glab auth login --hostname gitlab.a.com                    # une fois par instance
glab auth login --hostname gitlab.b.com
glab auth status                                           # vérifie tous les hosts

GITLAB_HOST=gitlab.b.com glab repo list                    # cible ponctuellement une instance
glab config set -g host gitlab.a.com                       # instance par défaut (globale)
glab config set --host gitlab.b.com git_protocol ssh       # réglage propre à un host
glab config get host
glab config edit                                           # ouvre ~/.config/glab-cli/config.yml
```

Ordre de résolution du host : remote du repo courant → `GITLAB_HOST` → `host` du config global.
Dans un repo cloné depuis `gitlab.b.com`, glab utilise automatiquement ce host — pas besoin de
`GITLAB_HOST`. Le config *local* (`.git/glab-cli/config.yml`, `glab config set` sans `-g`) permet
de forcer un réglage repo par repo.

```sh
# hosts avec endpoints séparés (API / SSH sur un autre nom ou port)
glab auth login --hostname gitlab.example.com \
  --api-host gitlab.example.com:3443 --api-protocol https --ssh-hostname ssh.example.com
```

Alias pratiques par instance :
```sh
alias glaba='GITLAB_HOST=gitlab.a.com glab'
alias glabb='GITLAB_HOST=gitlab.b.com glab'
```

## Repos
```sh
glab repo clone group/project                              # clone (protocole configuré)
glab repo clone group/project mydir
glab repo clone 4356677                                    # par ID de projet
glab repo clone group/project -- --depth 1 --branch main   # flags git après --
glab repo view group/project --web
glab repo list                                             # mes projets
glab repo search <terme>
glab repo create mon-projet --group mon-groupe --private
glab repo fork group/project --clone
glab repo archive group/project
```

## Clone en batch (groupe / sous-groupe)
```sh
glab repo clone -g mon-groupe --paginate                   # tous les repos du groupe
glab repo clone -g mon-groupe/mon-sous-groupe --paginate   # un sous-groupe
glab repo clone -g grp --archived=false --paginate         # exclut les archivés
glab repo clone -g grp -p --paginate dest/                 # arborescence namespace dans dest/
glab repo clone -g grp -G=false --paginate                 # sans descendre dans les sous-groupes
glab repo clone -g grp -S=false --paginate                 # sans les projets partagés au groupe
glab repo clone -g grp -m --paginate                       # seulement mes projets
glab repo clone -g grp -v private --paginate               # filtre par visibilité
GITLAB_HOST=gitlab.example.com glab repo clone -g grp --paginate
```

`--paginate` est indispensable au-delà de 30 repos (`--per-page` pour la taille de page).
`-G/--include-subgroups` et `-S/--with-shared` sont à `true` par défaut.

## Merge requests
```sh
glab mr list                                               # MR ouvertes du repo
glab mr list --assignee=@me --all
glab mr create --fill --yes                                # titre/desc depuis les commits
glab mr create --source-branch feat --target-branch main --draft
glab mr view 42 --web
glab mr diff 42
glab mr checkout 42                                        # checkout local de la MR
glab mr approve 42
glab mr merge 42 --squash --remove-source-branch
glab mr note 42 --message "LGTM"
glab mr close 42 / glab mr reopen 42
glab mr todo 42                                            # ajoute à ma to-do list
```

## CI/CD
```sh
glab ci status                                             # pipeline de la branche courante
glab ci list
glab ci view                                               # TUI des jobs du pipeline
glab ci run --branch main -v KEY:value                     # déclenche un pipeline
glab ci retry <job-id>
glab ci trace <job-id>                                     # logs en direct
glab ci lint                                               # valide .gitlab-ci.yml
glab ci artifact <ref> <job-name>                          # télécharge les artefacts
glab job list / glab job artifact ...
glab schedule list
```

## Variables, releases, divers
```sh
glab variable list / set KEY value --masked / delete KEY
glab variable list --group mon-groupe
glab release list
glab release create v1.0.0 --notes "..." ./dist/*
glab snippet create --title "..." --filename x.sh
glab token create --name ci --scopes api --expires-at 2026-12-31
glab api /projects/:id/pipelines                           # appel API brut authentifié
glab api groups/mon-groupe/projects --paginate
glab search code "func main"
```

## Config utile
```sh
glab config set -g editor nvim
glab config set -g git_protocol ssh
glab config set -g browser firefox
glab config set -g glab_check_update false
glab completion -s zsh                                     # complétion (auto via brew/fpath)
glab check-update
```
