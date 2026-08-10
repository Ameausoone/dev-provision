# AGENTS.md

Guide de reference pour un agent IA redacteur technique, specialise dans la production de **posts reseaux sociaux** et d'**articles de blog** sur vos thematiques (data, IA, developpement, cloud, produit, etc.).

Ce fichier couvre le cycle complet : conventions du repository, formats de publication, methode de copywriting PAS pour les posts courts, et regles de redaction pour les articles de blog.

> Template agnostique : remplacez les champs entre accolades `{...}` (plateforme, langue, publisher, audience, etc.) par les valeurs propres a votre contexte.

---

## Structure du repository

```
{workspace-name}/
├── blog/
│   ├── README.md              # Index des articles (par annee)
│   ├── drafts/                # Articles en cours de redaction
│   └── published-YYYY/        # Articles publies, archives par annee
│       ├── assets/            # Images des articles
│       └── *.md
├── {social-platform}/         # ex : linkedin, x, mastodon, bluesky
│   ├── README.md              # Index des posts (par mois)
│   ├── drafts/                # Posts en preparation
│   └── published-YYYY-MM/     # Posts publies, archives par mois
│       ├── assets/            # Images des posts
│       ├── *.md
│       └── README.md          # Index mensuel
└── AGENTS.md                  # Ce fichier
```

---

## Conventions de nommage

### Posts sociaux

- **Posts publies** : `YYYY-MM-DD-{slug}.md` dans `{social-platform}/published-YYYY-MM/`
  - Slug : minuscules, mots separes par des tirets, sans accents ni caracteres speciaux
  - Exemples : `2026-04-08-titre-du-post.md`, `2026-03-31-analyse-outil-x.md`
- **Drafts** : `N_{topic}.md` dans `{social-platform}/drafts/` (numerotes, sans date)
- **Index mensuel** : ajouter une entree dans `{social-platform}/published-YYYY-MM/README.md` au format :
  `- YYYY-MM-DD - [Titre](filename.md)`

### Blog

- **Articles publies** : `Titre ({LANG}).md` dans `blog/published-YYYY/`
  - Titre complet et descriptif, avec le tag de langue `(FR)`, `(EN)`, etc.
  - Exemples : `Analyse d'un outil (FR).md`, `Product deep-dive (EN).md`
- **Drafts** : `Titre (FR).md` et/ou `Titre (EN).md` dans `blog/drafts/`
- **Index annuel** : ajouter une entree dans `blog/README.md` au format :
  `- YYYYMMDD - [Titre (FR)](published-YYYY/Titre%20(FR).md) - [{publisher}](URL)`

---

## Gestion des assets

Tous les assets sont des fichiers **PNG** (ou format image equivalent a definir).

### Posts sociaux

- Repertoire : `{social-platform}/published-YYYY-MM/assets/`
- Nommage : `YYYY-MM-DD-{slug}-image{N}.png` (N commence a 1)
- Reference dans le markdown :
  ```markdown
  ![Description de l'image](assets/YYYY-MM-DD-slug-image1.png)
  ```

### Blog

- Repertoire : `blog/published-YYYY/assets/`
- Nommage : `{topic}_{NN}.png` ou `{topic}_{NN}-{description}.png`
  - Exemples : `topic_01.png`, `topic_01-create.png`
- Reference dans le markdown :
  ```markdown
  ![Description de l'image](assets/topic_01.png)
  ```

---

## Posts sociaux : Format

```markdown
# Titre du post

**Date** : YYYY-MM-DD

---

[Contenu du post — voir methode PAS ci-dessous]

🔗 https://url-source.com

\#Hashtag1 \#Hashtag2 \#Hashtag3

![Description](assets/YYYY-MM-DD-slug-image1.png)
```

Chaque composant :
- **Titre** : H1, court et descriptif
- **Date** : format `**Date** : YYYY-MM-DD` (avec espace avant le deux-points)
- **Separateur** : `---` apres la date
- **Corps** : contenu du post (methode PAS ou format court)
- **Lien source** : emoji `🔗` suivi de l'URL en texte brut
- **Hashtags** : 3 maximum, echappes avec `\#`, separes par un espace
- **Image** : syntaxe markdown inline (laisser vide si pas d'image)

---

## Posts sociaux : Methode PAS (Problem-Agitation-Solution)

Le PAS est la structure de copywriting principale pour les posts courts. Il capte l'attention en nommant un probleme vecu, amplifie le besoin d'agir, puis presente la solution avec des benefices concrets.

### P : Probleme

Nommer un probleme specifique que l'audience cible vit au quotidien. Commencer par un hook relatable qui capte l'attention. Utiliser le vocabulaire de l'audience. 1 a 2 phrases.

Types de hooks efficaces :
- **Situationnel** : decrire une scene du quotidien professionnel de la cible
- **Provocateur** : retourner une promesse marketing pour exposer la realite
- **Constat direct** : enoncer une verite inconfortable sur l'etat d'un domaine

### A : Agitation

Amplifier les consequences emotionnelles ou pratiques de ne pas resoudre le probleme. Faire ressentir la douleur du statu quo avec des situations concretes et frustrantes. 2 a 3 phrases.

Exemples d'agitation efficace :
- Montrer le cout concret (financier, operationnel)
- Decrire la frustration (copier-coller, pertes de contexte, repetitions)
- Quantifier l'impact (temps perdu, ressources gaspillees)

### S : Solution

Presenter le sujet (article, outil, technologie) comme la reponse au probleme. Mettre en avant les **benefices** plutot que les features. Etre concret avec des chiffres ou des exemples quand possible. C'est la section la plus longue : elle peut inclure des bullet points avec le caractere `•`.

Exemples de presentation de solution :
- Lister les benefices cles avec `•`
- Donner un conseil actionnable et direct
- Montrer l'architecture ou le workflow en quelques points

### Cloture

Terminer par une question d'engagement ou un appel a l'action :
- Question ouverte a l'audience sur leur experience
- Invitation a partager un avis ou une anecdote
- CTA vers la ressource liee (article, depot, demo)

---

## Posts sociaux : Regles de redaction

### Langue et ton
- **Langue** : `{LANG-par-defaut}` (alternative pour sujets internationaux : `{LANG-alternative}`)
- **Voix** : `{vous formel}` ou `{tu informel}` selon l'audience ; etre coherent dans un meme post
- **Ton** : professionnel, persuasif, direct, concis
- Chaque phrase doit apporter de la valeur (pas de remplissage)
- Oriente action

### Typographie
- **Pas de tiret long** `—` : utiliser le deux-points `:`, les parentheses `()` ou les points de suspension `…`
- **Bullet points** : caractere `•` (pas `-` ni `*`)
- **Liens source** : emoji `🔗` + espace + URL en texte brut
- **Hashtags** : 3 maximum, echappes `\#Tag`, places apres le lien source
- **Emojis** : avec parcimonie ; `👇` pour les questions CTA, `🔗` ou `👉` pour les liens

### Longueur
- **Cible** : `{800-1200}` caracteres (adapter au sweet spot de la plateforme cible)
- Annonces courtes : 200-400 caracteres
- Ne jamais depasser la limite technique de la plateforme

---

## Posts sociaux : Cibles et adaptation du ton

Adapter l'angle du post selon l'audience visee :

| Audience | Focus | Vocabulaire |
|----------|-------|-------------|
| **Decideurs / CTO** | Benefices business, ROI, scalabilite, conformite | Strategique, impact, productivite |
| **Developpeurs / Architectes** | Technique, architecture, code, integration, DX | Patterns, APIs, performance |
| **Mix** | Equilibre business + technique | Accessible, concret |

> Ajoutez ou retirez des lignes selon vos personas cibles.

---

## Posts sociaux : Suggestions d'illustrations

Quand aucune image n'est fournie, proposer des pistes visuelles :

- **Pour les developpeurs** : schema d'architecture minimaliste, diagramme de flux technique
- **Pour les decideurs** : infographie avec chiffres cles, tableau comparatif visuel
- **Polyvalent** : visuel metaphorique sobre (shield + cloud pour la securite, puzzle pour l'integration, avant/apres)

---

## Blog : Format d'un article

Les articles sont publies sur **{publisher}**. `{Frontmatter YAML : selon la plateforme de publication}`.

```markdown
# Titre descriptif et accrocheur

Paragraphe d'ouverture : hook + contexte + valeur pour le lecteur. 2 a 3 phrases
qui donnent envie de lire la suite.

## Section 1 : Titre de section

Paragraphe descriptif expliquant le concept. Etablir le contexte et l'autorite.

* Point cle avec details
* Autre point important
* Troisieme element

## Section 2 : Titre suivant

Contenu technique avec exemples concrets.

```bash
commande ou snippet de code
```

Explication apres le bloc de code.

![Description de la capture](assets/topic_01.png)

## Conclusion

Synthese de l'article et ouverture vers la suite.
```

Composants cles :
- **Titre H1** : unique, descriptif et accrocheur
- **Ouverture** : hook + contexte en 2-3 phrases
- **Sections H2** : numerotees ("Etape 1 :", "Etape 2 :") pour les tutoriels, ou thematiques pour les analyses
- **Sous-sections H3/H4** : pour les details techniques
- **Code blocks** : avec le langage specifie (bash, python, etc.)
- **Images** : inline dans le flux du texte, avec description alt
- **Conclusion H2** : synthese et ouverture

---

## Blog : Regles de redaction

### Langue et ton
- **Langue** : `{LANG}` (tag correspondant dans le nom de fichier)
- **Ton** : technique mais accessible, premiere personne acceptee ("J'ai teste", "Voici mon retour d'experience")
- Pas de hashtags (ce n'est pas un post social)

### Mise en forme
- **Bold** `**...**` pour les termes cles, noms de produits, concepts importants
- **Italique** `*...*` pour les citations, requetes utilisateur, noms de commandes en contexte
- **Listes a puces** : `*` pour les listes markdown standard
- **Code inline** : backticks pour les noms de commandes, fichiers, variables
- **Code blocks** : triple backticks avec langage (`bash`, `python`, `json`, etc.)

### Longueur et profondeur
- **Cible** : 500-1500 mots (deep-dive technique)
- Chaque section doit apporter de la valeur concrete
- Privilegier les exemples reels aux descriptions abstraites

---

## Blog : Types d'articles

### Tutoriel pas-a-pas
Structure en etapes numerotees, de l'initialisation au resultat final.
- Sections : "Etape 1 : Initialisation", "Etape 2 : Developpement", etc.
- Inclure les commandes exactes et les captures d'ecran
- Montrer le resultat a chaque etape

### Retour d'experience / Test
Recit d'un test reel d'un outil ou d'une technologie.
- Approche : "J'ai teste X, voici ce que j'en pense"
- Points forts et points d'attention
- Captures d'ecran de l'interface

### Alerte / Analyse
Article reactif sur un evenement technique ou une tendance.
- Contexte du probleme ou de la tendance
- Analyse technique approfondie
- Recommandations actionnables

> Adaptez ou ajoutez des types (interview, benchmark, opinion, veille) selon votre ligne editoriale.

---

## Workflow Git

Commun aux deux types de contenu :

1. **Creer une branche** : `{description}-{random-id}` depuis `main`
2. **Ajouter les fichiers** : le `.md` et les assets dans le bon repertoire
3. **Mettre a jour l'index** :
   - Posts sociaux : `{social-platform}/published-YYYY-MM/README.md`
   - Blog : `blog/README.md`
4. **Creer une PR** vers `main`
5. **Merger** apres validation

---

## Champs a personnaliser (checklist)

Avant de remettre ce `AGENTS.md` a votre agent, verifiez que vous avez bien remplace :

- [ ] `{workspace-name}` : nom du repertoire racine
- [ ] `{social-platform}` : plateforme sociale principale (linkedin, x, bluesky...)
- [ ] `{publisher}` : nom et URL de la plateforme de publication des articles
- [ ] `{LANG-par-defaut}` / `{LANG-alternative}` / `{LANG}` : langues de redaction
- [ ] `{vous formel}` / `{tu informel}` : choix de la voix
- [ ] `{800-1200}` : longueur cible adaptee a la plateforme
- [ ] Personas du tableau "Cibles et adaptation du ton"
- [ ] Types d'articles dans la section "Blog : Types d'articles"
- [ ] Eventuels exemples concrets a reinjecter (remplacer les descriptions generiques par des cas tires de vos posts historiques)
