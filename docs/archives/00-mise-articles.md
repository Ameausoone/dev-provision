
# mise et la gestion des versions d’outils

👉 Remplacer asdf, nvm, pyenv & co
•	Installer mise et comprendre son fonctionnement
•	Gérer plusieurs versions de :
•	node, python, terraform, go, java, kubectl
•	Versions globales vs locales (mise.toml)
•	Lock de versions par projet
•	Migration depuis asdf

💡 Cas concret : un repo avec Node + Terraform + gcloud

# mise et les variables d’environnement

👉 Unifier env vars, fichiers .env et profils
•	Variables globales vs projet
•	Chargement automatique de .env
•	Surcharge par environnement (dev, staging, prod)
•	mise env vs direnv
•	Cas d’usage cloud / Kubernetes

# mise et la gestion des secrets

👉 Sans devenir un gestionnaire de secrets
•	Ce que mise fait et ne fait pas
•	Intégration avec :
•	Vault
•	1Password / SOPS
•	GitHub Actions secrets
•	Pattern recommandé : mise comme injecteur, pas comme coffre-fort
•	Anti-patterns à éviter (secrets en clair dans mise.toml)

# mise et les tasks

👉 Remplacer Makefile, npm scripts, just, bash
•	Définir des tasks (mise run)
•	Paramètres, dépendances, hooks
•	Tasks cross-platform (macOS / Linux / CI)
•	Organisation des tasks par domaine :
•	lint
•	test
•	deploy
•	Comparaison avec make, just, taskfile

# mise et la CI

👉 Rendre la CI identique au poste développeur
•	Installer mise dans GitHub Actions / GitLab CI
•	Cache des outils
•	Utiliser mise run dans les pipelines
•	Reproductibilité totale
•	Exemple :
•	local = CI = prod tooling

# mise et les monorepos

👉 Un seul outil, plusieurs stacks
•	Plusieurs mise.toml
•	Héritage et overrides
•	Node + Python + Terraform dans un même repo
•	Pattern “tooling as code”

# mise et le Platform Engineering

👉 Standardiser sans bloquer
•	mise comme socle d’outillage commun
•	Golden paths
•	Onboarding développeur en 5 minutes
•	Différence entre standardisation et verrouillage


# Structures d’articles pour la série `mise`

---

## 🧱 Structure 1 — Usage / How-to
**À utiliser pour :**
- mise et la gestion des versions d’outils
- mise et les variables d’environnement
- mise et les tasks

### 1. Le problème
Décrire la situation concrète sans `mise` : incohérences entre développeurs, versions différentes, scripts locaux non reproductibles, friction au quotidien.

### 2. Ce que `mise` apporte
Expliquer le rôle précis de `mise` sur ce sujet : ce qu’il simplifie, ce qu’il standardise, et ce qu’il ne cherche volontairement pas à faire.

### 3. Mise en œuvre (exemple)
Montrer un usage réel et minimal : un extrait de `mise.toml` et une ou deux commandes pour illustrer le fonctionnement.

### 4. À retenir
Synthèse courte :
- une bonne pratique essentielle
- une limite ou un piège à connaître

---

## 🧠 Structure 2 — Vision / Architecture
**À utiliser pour :**
- mise et la CI
- mise et les monorepos
- mise et le Platform Engineering

### 1. Le contexte
Présenter le problème à l’échelle équipe ou organisation : besoin de standardisation, de reproductibilité, d’onboarding rapide et de réduction de la dette d’outillage.

### 2. Le rôle de `mise`
Positionner clairement `mise` dans l’écosystème : ce qu’il prend en charge, ce qu’il délègue aux autres outils (CI, sécurité, build, runtime).

### 3. Modèle cible
Décrire le fonctionnement attendu avec `mise` : flux développeur, intégration CI, organisation monorepo ou plateformeable Engineering, sans centralisation excessive.

### 4. Points de vigilance
Lister les limites, les trade-offs et les erreurs de conception à éviter lors d’un usage à grande échelle.

---

## 🔁 Structure 3 — Article de clôture (REX)
**À utiliser pour :**
- article final de la série `mise`

### 1. Pourquoi `mise`
Rappel du contexte initial et des objectifs poursuivis à travers la série d’articles.

### 2. Ce qui a fonctionné
Bénéfices concrets observés : simplicité, adoption par les équipes, alignement entre local et CI.

### 3. Ce qui a posé problème
Limites rencontrées, résistances, cas où `mise` n’était pas la meilleure solution.

### 4. Recommandations
Conseils clairs et actionnables : pour quels contextes `mise` est pertinent, et dans quelles conditions il apporte le plus de valeur.


## Linkedin


Suite à un article de [Siegfried Ehret](https://sieg.fr/ied/avent-2025/04-mise/), puis de [Julien Wittouck](https://codeka.io/2025/12/19/adieu-direnv-bonjour-mise/) à propos de mise. J'ai découvert que, malgré mon usage régulier, j'avais loupé pas mal de choses sur cet outil prometteur. C'est donc l'occasion de creuser un peu plus cet excellent outil qu'est [mise]()

J'ai utilisé [asdf](https://asdf-vm.com/) pendant années pour gérer les versions de divers outils dans mon environnement de développement, avant que mon collègue [Jean-Yves Lenhoff](https://www.linkedin.com/in/jean-yves-lenhof-980b401/) me fasse découvrir mise.


## Annexes (optionnel)
- Ajouter une section “Migration depuis asdf” en 5 lignes max (si utile).
- Ajouter un snippet CI (GitHub Actions) dans l’article CI (Structure 2), pas ici.
