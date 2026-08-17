# Le socket Docker qui disparaît à chaque redémarrage

## Le symptôme

À chaque exécution du playbook suivant un redémarrage, une tâche — et une seule — ressortait en
`changed` :

```
TASK [mac_dev_playbook : Link Rancher Desktop Docker socket to /var/run/docker.sock]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/var/run/docker.sock",
-    "state": "absent"
+    "state": "link"
 }
```

Rancher Desktop expose son socket dans `~/.rd/docker.sock`. Le playbook créait un lien symbolique
depuis `/var/run/docker.sock` vers ce chemin, pour que les outils qui codent en dur l'emplacement
historique du socket (IDE, Testcontainers, scripts) fonctionnent sans configuration.

Le lien était bien créé, et à chaque reboot il avait disparu.

## La cause

Rien n'écrase le lien : c'est tout le répertoire qui est vidé.

```console
$ ls -ld /var/run
lrwxrwxrwx 1 root root 4 /var/run -> /run

$ findmnt -no FSTYPE,OPTIONS /run
tmpfs  rw,nosuid,nodev,size=6301820k,mode=755
```

`/var/run` est un lien vers `/run`, et `/run` est un **tmpfs** : un système de fichiers en mémoire.
Son contenu n'est jamais écrit sur disque et repart vide à chaque démarrage. C'est voulu — `/run`
contient l'état d'exécution du système (PID files, sockets), qui n'a aucun sens d'être conservé
d'un boot à l'autre.

La tâche était donc parfaitement idempotente : elle constatait `absent` et convergeait vers `link`.
Le problème n'était pas Ansible, mais le fait de provisionner un objet dans un répertoire volatil.

## La correction

Ce qui repeuple `/run` au démarrage, c'est `systemd-tmpfiles`. L'objet persistant à provisionner
n'est donc pas le lien, mais la règle qui le recrée — dans `/etc/tmpfiles.d/` :

```
L+ /run/docker.sock - - - - /home/<user>/.rd/docker.sock
```

`L+` crée un lien symbolique en remplaçant ce qui occupe éventuellement le chemin (l'équivalent du
`force: true` de l'ancienne tâche). Les cinq `-` sont les champs mode/propriétaire/groupe/âge,
sans objet pour un lien.

Le playbook écrit ce fichier puis exécute `systemd-tmpfiles --create` une fois, pour que le lien
existe dans la session courante sans attendre le prochain démarrage. Voir
[`tasks/docker.yml`](../roles/mac_dev_playbook/tasks/docker.yml).

Le fait que la cible n'existe pas encore au moment du boot n'est pas un souci : un lien pendant est
valide, il se résout dès que Rancher Desktop démarre et crée `~/.rd/docker.sock`.

## Et sur macOS ?

Pas de systemd, et `/var/run` (`/private/var/run`) n'y est pas un tmpfs. Le lien symbolique direct
y reste la bonne approche : les deux tâches sont donc conditionnées par `ansible_facts.os_family`.

## L'alternative écartée

Rancher Desktop recommande plutôt d'exporter `DOCKER_HOST` :

```bash
export DOCKER_HOST=unix://$HOME/.rd/docker.sock
```

Pas de root, pas de fichier système. Mais ça ne couvre que ce qui hérite de l'environnement du
shell — un outil qui ouvre `/var/run/docker.sock` en dur sans lire `DOCKER_HOST` ne voit rien.
Le lien reste la solution la plus universelle.
