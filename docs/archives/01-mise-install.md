# Standardiser les versions de vos outils avec mise

> Chaque développeur installe ses outils à sa façon. Résultat : des "ça marche chez moi" à n'en plus finir. `mise` règle ce problème en un fichier versionné — et quelques commandes.

À la fin de cet article, vous saurez installer et configurer [`mise`](https://mise.jdx.dev/) pour gérer les versions d'outils dans vos projets et garantir la cohérence entre développeurs et CI.

**Public** : Développeurs, DevOps, SRE

## Le problème des versions qui dérivent

Dans un projet typique, chaque développeur installe ses outils indépendamment. Un dev utilise Java 17, un autre Java 21. La CI utilise Terraform 1.5, alors que l'équipe a migré en local vers 1.9.

Résultat : des bugs inexplicables, des "ça marche chez moi", et des heures perdues à débugger des incompatibilités de versions. Les scripts d'installation manuels (`install-java.sh`, `setup-terraform.md`) dérivent, l'onboarding des nouveaux développeurs devient long et fastidieux.

## Ce qu'on va construire

À la fin de ce tutoriel, vous aurez `mise` installé et activé sur votre machine, un fichier `mise.toml` versionnant les outils du projet, et une installation automatique des bonnes versions selon le répertoire courant.

## Les concepts clés

**Déclaratif** : `mise` permet de déclarer dans un fichier [`mise.toml`](https://mise.jdx.dev/configuration.html) les versions exactes des outils nécessaires. Ce fichier est versionné avec le code.

**Activation automatique** : Lorsque vous entrez dans un répertoire contenant un `mise.toml`, `mise` active automatiquement les bonnes versions. Changez de projet, changez de versions automatiquement.

**Environnement reproductible** : Développeurs et CI utilisent le même `mise.toml`, garantissant un environnement strictement identique pour tous.

## [Installation de `mise`](https://mise.jdx.dev/installing-mise.html)

Commencez par installer l'outil sur votre machine :

```bash
# macOS avec Homebrew
brew install mise

# Linux
curl https://mise.run | sh

# Windows avec Scoop
scoop install mise
```

<!-- Installation de mise sur macOS (Homebrew), Linux (curl) et Windows (Scoop) -->

Vérifiez que tout fonctionne avec `mise --version`.

## Activation dans le shell

Pour que `mise` gère automatiquement les versions selon le répertoire, activez-le dans votre shell :

```bash
# macOS avec zsh
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc

# Linux avec bash
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

<!-- Activation de mise dans le shell zsh (macOS) et bash (Linux) -->

### Windows avec PowerShell

```powershell
$shimPath = "$env:USERPROFILE\AppData\Local\mise\shims"
$currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$newPath = $currentPath + ";" + $shimPath
[Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
```

<!-- Ajout du répertoire shims de mise au PATH sous Windows via PowerShell -->

Le shell charge maintenant `mise` automatiquement.

## Premier outil : installer Java localement

Pour installer java, vous pouvez utiliser la commande [`mise install`](https://mise.jdx.dev/cli/install.html) ou `mise i`:

```bash
$ mise install java@21
mise java@21.0.2       download openjdk-21.0.2_macos-aarch64_bin.tar.gz
openjdk version "21.0.2" 2024-01-16
OpenJDK Runtime Environment (build 21.0.2+13-58)
OpenJDK 64-Bit Server VM (build 21.0.2+13-58, mixed mode, sharing)
[...]
```

<!-- Installation de Java 21 via mise install — output de téléchargement et vérification de version -->

Que se passe-t-il ? `mise` télécharge et installe Java 21 dans son répertoire de gestion des outils (généralement `~/.local/share/mise/installs/java/21.0.2`). Vous pouvez vérifier.

```bash
$ tree -d -L 1 ~/.local/share/mise/installs/java/
~/.local/share/mise/installs/java/
├── 21 -> ./21.0.2
├── 21.0 -> ./21.0.2
├── 21.0.2
└── latest -> ./21.0.2
```

<!-- Arborescence du répertoire d'installation mise : symlinks de version (21 → 21.0.2) -->

Vous pouvez voir ici que `mise` gère les versions de manière intelligente : `java@21` pointe vers la dernière version 21.x, et `latest` pointe vers la dernière version stable (installée sur votre machine).

Vous pouvez aussi utiliser la commande [`mise use`](https://mise.jdx.dev/cli/use.html) pour activer une version localement dans un projet :

```bash
$ mise use java@21
mise config files in ~/Projects/my-project are not trusted. Trust them? Yes
mise ~/Projects/my-project/mise.toml tools: java@21.0.2

$ cat mise.toml
[tools]
java = "21"
```

<!-- Activation de Java 21 dans un projet avec mise use, et contenu du mise.toml généré -->

Que se passe-t-il ? Si mise trouve un `mise.toml` dans le répertoire courant (ou dans un parent), il active les versions d'outils déclarées. Sinon, `mise` créait le fichier `mise.toml` avec la configuration demandée.

Vérifiez que Java 21 est actif :

```bash
$ which java
/Users/username/.local/share/mise/installs/java/21.0.2/bin/java
$ java -version
openjdk 21.0.2 2024-01-16
OpenJDK Runtime Environment (build 21.0.2+13-58)
OpenJDK 64-Bit Server VM (build 21.0.2+13-58, mixed mode, sharing)
```

<!-- Vérification que Java 21 géré par mise est bien actif dans le projet courant -->

Java 21 est actif uniquement dans ce répertoire. Sortez du projet, et vous retrouvez votre version système.

## Installer différents outils

`mise` supporte une large gamme d'outils : Java, Node.js, Python, Terraform, Docker, kubectl, et bien d'autres. Lancez `mise use` sans argument pour ouvrir une interface interactive (TUI) et parcourir [tous les outils disponibles](https://mise.jdx.dev/registry.html) :

```bash
$ mise use
Tools
Select a tool to install
❯ 1password           Password manager developed by AgileBits Inc
  aapt2               Android Asset Packaging Tool (aapt)
  act                 Run your GitHub Actions locally
  action-validator    Tool to validate GitHub Action and Workflow YAML files
  actionlint          :octocat: Static checker for GitHub Actions workflow files
  adr-tools           Command-line tools for working with Architecture Decision Records
  ag                  The Silver Searcher: A code searching tool similar to ack, with a focus on speed
  age                 A simple, modern and secure encryption tool (and Go library) with small explicit keys, no config options, and UNIX-style composability
  age-plugin-yubikey  age-plugin-yubikey is a plugin for age clients like age and rage, which enables files to be encrypted to age identities stored on YubiKeys
[...]
```

<!-- Interface interactive (TUI) de mise use : navigation dans le registre des outils disponibles -->

Avec `mise use`, vous avez toute la liste des outils disponibles avec `mise`. Vous pouvez rechercher, installer et activer n'importe quel outil avec une seule commande.

## Créer un fichier `mise.toml`

Plutôt que d'utiliser la commande `use` pour chaque outil, éditez directement `mise.toml` à la racine du projet :

```toml
[tools]
java = "21.0.1"
terraform = "1.9.8"
node = "20.11.0"
```

<!-- Exemple de mise.toml déclarant Java, Terraform et Node.js avec des versions précises -->

Et installez tous les outils d'un coup :

```bash
$ mise install
mise java@21.0.1       download openjdk-21.0.1_macos-aarch64_bin.tar.gz
mise terraform@1.9.8   download terraform_1.9.8_darwin_arm64.zip
mise node@20.11.0     download node-v20.11.0-darwin-arm64.tar.gz
```

<!-- Installation de tous les outils déclarés dans mise.toml en une seule commande -->

Tous les outils déclarés sont téléchargés et configurés.

## Outils globaux

Pour installer des outils disponibles dans tous vos projets (pas seulement le projet courant), utilisez le flag `--global` ou `-g` :

```bash
mise use --global node@20
mise use --global python@3.12
```

<!-- Installation d'outils globaux avec mise use --global, disponibles dans tous les projets -->

`mise` mets à jour votre configuration globale (`~/.config/mise/config.toml`) et installe les outils.

## Commandes utiles

```bash
# Lister tous les outils installés (locaux et globaux)
mise ls

# Vérifier la santé de mise
mise doctor

# Voir quelle version est active pour un outil
mise current java

# Voir quel binaire est utilisé
mise which terraform
```

<!-- Commandes utiles mise : lister, diagnostiquer et inspecter les outils installés -->

## Personnalisation avancée

`mise` supporte des options avancées comme spécifier une version "glissante" d'un outil. Par exemple, vous pouvez spécifier `terraform = "1.12"` pour toujours utiliser la dernière version mineure de Terraform 1.12.x.

Pour Java, il existe une multitude de [distributions (OpenJDK, Zulu, Liberica, etc.)](https://mise.jdx.dev/lang/java.html). Choisissez une distribution spécifique directement dans `mise.toml` :

```toml
[tools]
# OpenJDK par défaut
java = "latest"
# Eclipse Temurin 21 (LTS)
java = "temurin-21"
# Zulu précis
java = "zulu-17.0.8"
```

<!-- Sélection d'une distribution Java spécifique (OpenJDK, Temurin, Zulu) dans mise.toml -->

## Récap

`mise` simplifie radicalement la gestion des versions d'outils. En quelques minutes, vous passez d'un environnement fragmenté à une configuration standardisée et reproductible.

Installez `mise`, créez un `mise.toml` versionnant les outils du projet, et utilisez `mise install` pour installer automatiquement les dépendances.

**Next steps** : Versionnez `mise.toml` dans votre repository, configurez `mise` dans votre CI/CD, et explorez les variables d'environnement pour configurer vos projets.

## Ressources

- [Documentation officielle mise](https://mise.jdx.dev/)
- [GitHub mise - Code source](https://github.com/jdx/mise)
- [Comparaison avec asdf](https://mise.jdx.dev/comparison-to-asdf.html)
- [Liste des outils supportés](https://mise.jdx.dev/registry.html)

### Pour aller plus loin

- [Industrialisez vos pipelines Dataflow avec la CI/CD](https://www.sfeir.dev/cloud/industrialisez-vos-pipelines-dataflow-avec-la-ci-cd/)
- [Les modules Terraform dans un gros projet](https://www.sfeir.dev/cloud/les-modules-terraform-dans-un-gros-projet-comment-nous-lavons-decompose/)
- [Infrastructure as Code : définition](https://www.sfeir.dev/kesaco/infrastructure-as-code-definition/)
