# Développeur: prenez le contrôle de votre poste, et commencez à provisionner vos "dotfiles" !

## Comment j'ai commencé ?

J'ai commencé à provisionner mon poste lorsque j'ai commencé à travailler sur MacOS il y a plus de 6 ans.

J'ai utilisé Ansible parce que c'est un outil que j'utilisais au quotidien et que je connaissais bien, sachant que je n'allais probablement moins l'utiliser dans mon travail, c'était une occasion de garder la main. Ansible est d'ailleurs un peu overkill pour ce besoin, je ne sais si je le conseillerais si vous partez de 0.

## Concrètement ?

2 commandes:
* `macconfig` pour ouvrir mon projet dans IntelliJ
* `macans` pour appliquer ma configuration

## Pourquoi ?

J'ai commencé à provisionner mon poste pour plusieurs raisons:

* J'avais déjà entendu parler de la pratique des dotfiles et je voulais m'y mettre.
* Je voulais pouvoir réinstaller mon poste rapidement (même si ça arrive très rarement).
* Mais ma première motivation était surtout de maîtriser la configuration de mon poste.

## On commence par quoi ?

J'ai commencé par un playbook assez simple, j'ai listé déjà les outils que j'utilisais et que j'installais avec `brew`.

```yaml
mac_dev_playbook_homebrew_installed_packages:
  - adr-tools         # adr-tools is a command line tool for working with Architecture Decision Records
  - autoenv           # autoenv execute .env file when you cd into a directory
  - autojump          # autojump is a faster way to navigate your filesystem
  - antigen           # package manager for zsh
  - bash-completion   # bash-cbwompletion is a collection of bash completion scripts
  - bats              # Bats is a Batch Test Suite
  - git               # Git is a version control system
  - htop              # htop is an interactive process viewer
  - jq                # jq is a lightweight and flexible command-line JSON processor
```

Que j'installe avec la tâche suivante :

```yaml
- name: Install homebrew package
  failed_when: false
  community.general.homebrew:
    name: "{{ mac_dev_playbook_homebrew_installed_packages }}"
    state: present
    upgrade_all: true
```

Histoire de pouvoir faire le ménage facilement, j'ai également ajouté une tâche pour désinstaller les paquets que je n'utilisais plus et garder mon poste clean !

Ensuite, j'ai provisionné quelques alias bien pratique comme:

```shell
# Un facilitateur pour find et grep
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Un racourci pour mkdir et cd
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Quelques alias pour gagner du temps
alias ..="cd .."
alias m="make"
alias k="kubectl"
alias tf="terraform"
...
```

Et ceux notamment que j'utilise encore tous les jours pour provisionner mon poste:

```shell
# Ouvres le projet dev-provision dans IntelliJ
alias macconfig="idea ${MACOS_SETUP_DIR}"

# Ce script va dans le répertoire dev-provision, puis il lance git add, commit et push, puis il lance le playbook ansible, all-in-one
function macans() {
  cd ${MACOS_SETUP_DIR}/dev-provision && \
  gitandans $1
}
```

`macconfig` et `macans` sont vraiment les 2 alias essentiels pour provisionner mon poste. Je les utilise pratiquement tous les jours. Et c'est le secret pour prendre l'habitude de provisionner son poste: il faut que le processus soit simple et rapide.

## Mes outils préférés

### zsh et oh-my-zsh

Assez rapidement, j'ai découvert des outils bien pratique et notamment `zsh` et très rapidement `oh-my-zsh`.

`zsh` ajoute énormèment de fonctionnalité très pratique à votre shell, et `oh-my-zsh` va les exploiter pour avoir un shell "sous stéroïde".

La première fonctionnalité et pour moi la plus importante, c'est l'auto-complétion. C'est une fonctionnalité que j'utilise tous les jours et qui me fait gagner un temps fou. Si vous n'utilisez pas encore l'auto-complétion, arrêtez tout et allez me configurer ça !

Un exemple avec Git:

```shell
$ git chec<TAB>
$ git checkout
$ git checkout <TAB>
$ git checkout master
$ git checkout master <TAB>
$ git checkout master --<TAB>
$ git checkout master --force
```

A chaque fois que vous appuyez sur `<TAB>`, `zsh` va vous proposer les options possibles. Et si vous avez plusieurs options possibles, il va vous les proposer toutes. L'auto-completion ne se content pas de vous lister les options possibles, il peut exécuter des commandes pour avoir des infos live, comme par exemple les branches existantes sur le repo distant, ou les pods existants sur votre cluster Kubernetes avec `kubectl`. Un must-have !

Vous avez beaucoup de plugins "out of the box" avec `oh-my-zsh` et vous pouvez en ajouter facilement. Quelques exemples dans mon fichier [01_oh-my-zsh-plugins.zsh](https://github.com/Ameausoone/dev-provision/blob/main/roles/mac_dev_playbook/files/.zshrc.d/core/01_oh-my-zsh-plugins.zsh#L6), et la liste exhaustive est disponible [ici](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins).

### asdf

`asdf` est un outil qui permet de gérer plusieurs versions d'un même outil. Par exemple, vous pouvez avoir plusieurs versions de `terraform` ou de `python` installées sur votre poste et `asdf` va vous permettre de les gérer facilement, plus facilement qu'avec `tfswitch` ou `pyenv` par exemple.

La grosse différence entre `asdf` et tous les autres outils de gestion de version, et que `asdf` est un outil générique, il peut gérer n'importe quel outil, ET il permets de gérer plusieurs version -en même temps- d'un même outil.

Comment ça marche ?

Quand vous allez installer le plugin `terraform` pour `asdf`. `asdf` va installer un wrapper dans le répertoire `$HOME/.asdf/shims/terraform` (que vous devez ajouter dans votre `$PATH`). Ce wrapper va remonter le répertoire courant jusqu'à trouver un fichier `.tool-versions` qui contient la version de `terraform` à utiliser, et lancer cette version de `terraform`.

Vous pouvez donc travailler sur 2 projets en même temps avec 2 versions différentes de `terraform` sans avoir à changer de version à chaque fois.

### security

`security` est un outil qui permet de gérer les credentials dans le trousseau d'accès de MacOS. C'est très pratique, vos secrets sont chiffrés en local, et accessible via la commande `security`.

### autoenv

`autoenv` est un outil qui va permettre de lancer des scripts, comme charger des variables d'environnements, lancer une script, lorsque vous allez dans un répertoire (ou quand vous le quittez).

### Powerlevel10k

`Powerlevel10k` est un thème pour `zsh` qui permet d'avoir un prompt très complet et très configurable. Il est très facile à configurer et très rapide. Il est également très complet et permet d'afficher beaucoup d'informations sur votre prompt, comme:
* le temps d'exécution de la dernière commande
* le résultat de la dernière commande
* l'état de votre repo git
* virtualenv
* kubernetes
* ...

## Structure du projet

### .zshrc

Le fichier `.zshrc` est le fichier de configuration de `zsh`. Il est chargé à chaque fois que vous lancez un nouveau shell. C'est le point d'entrée pour pimper votre shell.

Donc, à force de rajouter des éléments, la situation peut devenir assez complexe. C'est pourquoi j'utilise un pattern pour distribuer les fichiers dans un sous-répertoire.

```shell
for file in ~/.zshrc.d/*/*.zsh;
do
  source $file
done
```

Ok donc ensuite comment le répertoire est organisé ?

```shell
├── .zshrc.d
│   └── core
│       ├── aliases.zsh
│       ├── ansible.zsh
│       ├── asdf.zsh
│       ├── autojump.zsh
│       ├── colima.zsh
│       ├── docker.zsh
│       ├── env.zsh
│       ├── fluxcd.zsh
│       ├── golang.zsh
│       ├── gcloud.zsh
│       ├── npm.zsh
│       ├── oh-my-zsh-plugins.zsh
│       ├── pip.zsh
```

### scripts

Ensuite, le contenu de ces scripts dépend. Nous y trouverons de nombreuses variables d'environnement, l'activation de l'autocomplétion, ainsi que diverses configurations.

Quelques exemples:

autojump.zsh
```shell
#!/usr/bin/env zsh

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
```

ansible.zsh
```shell
alias a="ansible"
alias ap="ansible-playbook"
alias apd="ansible-playbook --diff"
alias apdv="ansible-playbook --diff --verbose"
```

autoenv.zsh
```shell
source "$(brew --prefix autoenv)/activate.sh"
```

p10k.zsh
```shell
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

gcloud.zsh
```shell
# Aliases for gcloud
# Authenticate
alias g='gcloud'
alias gauth='gcloud auth login --update-adc'
alias gke='gcloud container'
alias gke-list='gcloud container clusters list'
alias gke-credentials='gcloud container clusters get-credentials'

# Autocompletion
# The next line updates PATH for the Google Cloud SDK.
source "$(asdf where gcloud)/path.zsh.inc"

# The next line enables zsh completion for gcloud.
source "$(asdf where gcloud)/completion.zsh.inc"
```

### Priorité

Alors, un problème qui est survenu assez rapidement concerne la dépendance entre ces différentes configurations, par exemple au niveau du script de passe ou d'un script qui dépend d'autres scripts. J'utilise un modèle bien connu sous Linux pour gérer cette situation.

```shell
├── .zshrc.d
│   └── core
│       ├── 00_antigen.zsh
│       ├── 01_oh-my-zsh-plugins.zsh
...
│       ├── 10_ansible.zsh
│       ├── 10_mise.zsh
│       ├── 10_autojump.zsh
│       ├── 10_coreutils.zsh
│       ├── 10_npm.zsh
│       ├── 10_pip.zsh
...
│       ├── 20_gnupg.zsh
│       ├── 20_golang.zsh
│       ├── 50_colima.zsh
│       ├── 50_docker.zsh
...
│       ├── 50_gh.zsh
│       ├── 50_git.zsh
│       ├── 80_autoenv.zsh
│       ├── 80_p10k.zsh
│       └── 90_antigen.zsh
```

### dotfiles

Ensuite je gère mes dotfiles dans mon repo, j'ai peu de configuration, je noterais notamment `asdf` avec les version des outils que j'utilise:

.tools-version
```shell
conftest v0.23.0
flux2 0.22.1
gcloud 415.0.0
hugo 0.107.0
helm 3.6.0
kubectl 1.18.16
kustomize 4.4.0
```

.p10k.zsh
```shell
[...]
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    direnv
    asdf
[...]
```

### .gitconfig

Je voudrais prendre un exemple de comment vous pouvez investir dans la configuration de votre poste à travers un bon exemple: Git.

Et j'ai surtout de la configuration pour `git`, en commençant par le `.gitconfig`, que je vais détailler:

.gitconfig
```text
[user]
  name = AMeausoone
...
  signingkey = {{ gpg_key }}
[credential]
  helper = osxkeychain
```

`signingkey` est la clé GPG que j'utilise pour signer mes commits. Ici j'ai templatisé la valeur avec Ansible en fonction de mon poste, mais vous pouvez la mettre en dur.

`oskeychain` est un utilitaire qui permet de stocker les credentials dans le trousseau d'accès de MacOS. C'est très pratique, car vous n'avez pas à rentrer vos credentials à chaque fois que vous faites un push.

```text
[push]
  default = simple
[pull]
  rebase = true
[fetch]
  prune = true
```

`default = simple` permet de faire un push simple, c'est à dire que vous n'avez pas besoin de spécifier la branche à chaque fois que vous faites un push.
`rebase = true` permet de faire un rebase au lieu d'un merge quand vous faites un pull(et c'est infiniment plus pratique).
`prune = true` permet de supprimer les branches locales qui n'existent plus à distance.

```text
[core]
  excludesfile = ~/.gitignore
```

`excludesfile` permet de spécifier un fichier qui contient les fichiers à ignorer. C'est très pratique pour ne pas avoir à les spécifier dans le `.gitignore` du projet, notamment pour les fichiers spécifiques à votre OS ou à votre IDE.

.gitignore
```text
# MacOS
*.DS_Store
*.LSOverride
Thumbs.db
.bundle

# IntelliJ
.idea/
*.iml

# VsCode
.vscode/
```

Si vous utilisez conventional commits, vous pouvez enregistrer un template de message de commits

.gitconfig
```text
[commit]
  template = ~/.gitmessage
```

.gitmessage
```text
<type>(<scope>): <subject>

<body>

<footer>

# Allowed <type>
#   feat (feature)
#   fix (bug fix)
#   docs (documentation)
#   style (formatting, missing semi colons, …)
#   refactor
#   test (when adding missing tests)
#   chore (maintain)
```

### secret management

Un autre exemple de mauvaises pratiques, que vous pouvez améliorer grâce au provisionning de votre poste, c'est la gestion des credentials: la pire façon de mettre des variables d'environnements est de le mettre en clair dans votre zshrc:
  ```shell
  export API_TOKEN="faketoken"
  ```

Vous avez pléthore d'outil pour améliorer ça, sur MacOs, j'utilise `security` qui permet de stocker les credentials dans le trousseau d'accès de MacOS. C'est très pratique, vos secrets sont chiffrés en local, et accessible via la commande `security`.

```shell
security find-generic-password -a "${LOGNAME}" -s "${keychain_entry}" -w
```

Il existe également des commandes pour les LastPass, Vault, gcloud, etc...

Et si vous utilisez `autoenv`, vous pouvez charger vos secrets automatiquement quand vous allez dans un répertoire.

### Publique/Privée

Un autre point important concerne la séparation entre les parties publiques et privées de votre configuration. J'ai open-sourcé une partie de ma configuration, mais j'ai toute une partie de mes scripts qui sont dédiés à mon travail chez mes clients, et qui ne sont pas publiques. Le jour où j'ai décidé de publier ma configuration, j'ai dû faire une vraie séparation dans ma configuration, et j'ai également dû effacer l'historique de mon repo git.

## Conclusion

### Qu'est-ce que ça m'a apporté ?

Le provisionning de mon poste m'a apporté beaucoup de choses:
* J'ai appris à mieux connaître les outils que j'utilise
* Un conseil, prenez l'habitude de parcourir la documentation de vos outils, vous allez apprendre des choses
* Powerlevel10k est une mine d'or, il y a énormèment de fonctionnalités que je n'utilise pas encore
* À capitaliser sur mon poste de travail, puisque je ne risque pas de perdre ma configuration, et que je peux la réutiliser facilement sur un autre poste.

### Comment démarrer ?

* N'utilisez pas un projet existant, créez le votre !
* Ansible est probablement overkill pour provisionner votre poste, mais vous trouverez énormément d'infos sur internet
* Notamment sur [dotfiles.github.io](https://dotfiles.github.io/) qui propose plein d'outils pour gérer vos dotfiles.
* Il vous faut 2 commandes: 1 pour ouvrir votre projet dans votre IDE, et 1 pour appliquer votre configuration.

### Pour aller plus loin ?

* Mettre en place des tests pour vos scripts
* Regarder comment fonctionne `nix-shell`
* Utilises un IDE en ligne, comme [Gitpod](https://www.gitpod.io/), [Codespaces](https://docs.github.com/en/codespaces/overview), etc...
