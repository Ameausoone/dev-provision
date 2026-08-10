//  pragma: allowlist secret
# Gestion sécurisée des secrets avec macOS Keychain et autoenv

La gestion des secrets et variables d'environnement sensibles est un enjeu crucial pour tout développeur. Stocker des tokens, clés API ou mots de passe en clair dans des fichiers `.env`, `.zshrc` ou pire, les laisser traîner dans l'historique bash, peut représenter un risque de sécurité.

Cet article présente une approche sécurisée pour macOS qui combine :
- Le **Keychain macOS** pour un stockage chiffré des secrets
- Des **fonctions shell personnalisées** pour une interface simple
- **autoenv** pour le chargement automatique par répertoire

## Problématiques des approches classiques

### ❌ Stockage en clair dans des fichiers

La méthode la plus courante consiste à stocker les secrets directement dans des fichiers de configuration ou des scripts shell, par exemple :
  ```bash
  # .env ou .zshrc
  export API_TOKEN="sk_live_xxxxxxxxxxxx"  # pragma: allowlist secret
  export DATABASE_PASSWORD="motdepasse123"  # pragma: allowlist secret
  ```

Les secrets stockés en clair dans les fichiers `.envrc` peuvent être exposés lors de commits accidentels dans Git, du partage d'écran, ou être accessibles à tout processus ayant accès au système de fichiers.

### ❌ Historique bash compromis

Une autre pratique dangereuse consiste à taper des commandes contenant des secrets directement dans le terminal, laissant des traces permanentes dans l'historique.
  ```bash
  # Commandes visibles dans l'historique
  export SECRET_KEY="ma-cle-secrete"  # pragma: allowlist secret
  curl -H "Authorization: Bearer mon-token" api.example.com
  ```

Les commandes contenant des secrets restent dans `~/.zsh_history`, sont accessibles via `history | grep token`, visibles par tous les utilisateurs du système et persistent même après redémarrage.

## Solution : Trousseau de clé MacOS

La cli `security` intégrée à macOS permet de gérer le Keychain, un stockage sécurisé et chiffré pour les secrets. Cependant, son usage direct est peu ergonomique. C'est pourquoi j'ai créé des fonctions shell pour simplifier l'interaction. Le fichier [`30_creds.zsh`](https://github.com/Ameausoone/dev-provision/blob/main/roles/mac_dev_playbook/files/.zshrc.d/core/30_creds.zsh) fournit une interface sécurisée pour le Keychain macOS. Ces fonctions encapsulent les commandes `security` système pour simplifier l'usage.

#### Ajout d'un secret

Pour ajouter un nouveau secret au Keychain, utilisez la fonction `creds_upsert_local_secret` qui garantit un stockage sécurisé et chiffré.

```bash
creds_upsert_local_secret "myservice" "api_key"
# Vous serez invité à saisir le secret de manière masquée
```

La fonction vérifie l'existence d'une entrée dans le Keychain, la supprime si nécessaire, puis crée une nouvelle entrée chiffrée en utilisant votre nom d'utilisateur comme identifiant.

#### Récupération d'un secret

Pour accéder à un secret stocké dans le Keychain, utilisez la fonction `creds_get_local_secret` qui récupère la valeur de manière sécurisée.

```bash
# Récupération directe pour usage immédiat
export API_TOKEN=$(creds_get_local_secret "myservice" "api_key")

# Stockage dans une variable pour usage multiple
my_token=$(creds_get_local_secret "myservice" "api_key")
echo "Token length: ${#my_token}"
```

**Sécurité :** Le secret est stocké de façon chiffrée dans le Keychain macOS, et chargé temporairement en mémoire.

#### Suppression d'un secret

Quand un secret n'est plus nécessaire, supprimez-le définitivement du Keychain pour maintenir une hygiène de sécurité optimale.

```bash
# Suppression définitive du Keychain
creds_delete_local_secret "myservice" "api_key"
```

Cette solution offre un stockage chiffré avec authentification système via Touch ID, sans laisser de traces en clair dans les fichiers. Les secrets sont chargés à la volée depuis le Keychain, et s'intègrent nativement avec tous les outils macOS.

### 2. Configuration des variables d'environnement

Comme indiqué plus haut, vous pouvez maintenant charger les secrets dans vos variables d'environnement de manière sécurisée. Voici un exemple simple d'un fichier `.zshrc` qui charge automatiquement une clé API au démarrage du shell.

```bash
#!/usr/bin/env zsh

# Récupération de la clé API depuis le Keychain
export API_TOKEN=$(creds_get_local_secret "myservice" "api_key")
```

### Comment charger mes secrets automatiquement par projet ?

La solution précédente est efficace, mais elle charge les secrets globalement à chaque ouverture de terminal. Pour une meilleure isolation et sécurité, il est préférable de charger les secrets uniquement dans le contexte d'un projet spécifique.

[**autoenv**](https://github.com/hyperupcall/autoenv) est un outil qui exécute automatiquement des scripts quand vous naviguez vers un répertoire. **L'avantage principal** : les secrets ne sont chargés que quand vous en avez besoin, dans le contexte du projet spécifique, plutôt que d'être disponibles globalement dans votre shell.

Cela permet de :
- **Charger les secrets uniquement par projet** : évite l'exposition inutile de tokens
- **Isolation des environnements** : chaque projet a ses propres variables
- **Chargement automatique** : pas besoin de se souvenir de commandes manuelles

#### Installation et configuration

```bash
# Installation via Homebrew
brew install autoenv

# Activation dans votre shell (ajout à ~/.zshrc)
echo 'source $(brew --prefix autoenv)/activate.sh' >> ~/.zshrc

# Rechargement de la configuration
source ~/.zshrc
```

#### Fonctionnement détaillé

**1. Détection automatique :**
Quand vous entrez dans un répertoire avec `cd`, autoenv cherche un fichier `.env`.

**2. Exécution sécurisée :**
```bash
# Première fois : autoenv demande confirmation
cd /mon/projet
# autoenv: WARNING: /mon/projet/.env is not trusted.
# Do you want to allow this? (y/N)
```

**3. Exemple de fichier `.env` simple :**

```bash
#!/usr/bin/env zsh

# Chargement simple des secrets depuis le Keychain
export API_TOKEN=$(creds_get_local_secret "myservice" "api_key")
export DATABASE_URL=$(creds_get_local_secret "myproject" "database_url")
export EXTERNAL_API_KEY=$(creds_get_local_secret "external" "api_key")
```

Lorsque vous naviguez vers un projet avec `cd`, autoenv détecte automatiquement le fichier `.env`, demande éventuellement votre authentification Keychain, puis charge les variables d'environnement qui deviennent disponibles pour tous vos outils.

## Comparaison avec d'autres solutions

Plusieurs solutions existent pour gérer les secrets. Les services tiers offrent une gestion centralisée et des droits d'accès granulaires, mais nécessitent une authentification supplémentaire et une interface moins fluide que le Keychain local de macOS.

Petite comparaison non exhaustive des solutions :

| Solution               | Sécurité | Simplicité | Intégration macOS |
|------------------------|----------|------------|------------------|
| **Keychain + autoenv** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Fichiers .env          | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| HashiCorp Vault        | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| GCP Secrets Manager    | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |

## Conclusion

Cette approche offre un équilibre optimal entre sécurité et productivité pour les développeurs macOS. En combinant le Keychain système, autoenv et des fonctions shell sur mesure, nous obtenons :

- **Sécurité renforcée** : Chiffrement matériel, pas de stockage en clair
- **Expérience développeur fluide** : Chargement automatique, interface simple
- **Maintenabilité** : Configuration centralisée, gestion d'erreurs robuste

L'investissement initial en configuration est rapidement rentabilisé par la tranquillité d'esprit et la réduction des risques de sécurité.

## Ressources

- [Documentation**** security(1)](https://ss64.com/osx/security.html)
- [autoenv sur GitHub](https://github.com/hyperupcall/autoenv)
- [Guide de sécurité Apple](https://support.apple.com/guide/keychain-access/)
