

# Playbook de Ansible para MacOS

Este es un Playbook de Ansible para provisionar mi macOS.

## ¿Qué proporciona este playbook?

Se encargará de:

* Crear directorios útiles.
* Instalar paquetes (brew (y taps), asdf, npm).
* Copiar dotfiles que configuran varias aplicaciones (Git, npm, terraform, asdf) en el directorio home.
* Copiar algunos scripts de zsh, principalmente para la configuración y algunas funciones auxiliares y alias.

## ¿Cómo instalarlo por primera vez?

* Instalar brew: [brew.sh/](https://brew.sh/)
* Instalar ansible: `brew install ansible`
* Clonar el proyecto en `~/Projects/wk_perso/macos-setup/macos-provision`.
* Copiar `roles/mac-dev-playbook/files/ansible/ansible.cfg` en `~/.ansible.cfg`
  ```shell
  curl -fsSL https://github.com/Ameausoone/macos-provision/raw/refs/heads/main/roles/mac_dev_playbook/files/HOME/ansible.cfg -o ~/ansible.cfg
  ```
* Inicializar el archivo `inventory` en `~/.ansible/inventory`, por ejemplo:

```text
[localhost]
${HOSTNAME}
```

* Luego, dirígete a `~/Projects/wk_perso/macos-setup/macos-provision`.
* Ejecuta `ansible-playbook main.yml --diff --verbose --inventory ~/.inventory --limit $(hostname)`.
* Autenticarse en GitHub
  ```shell
  gh auth login
  ```
* Cambiar la shell por defecto
  ```shell
  chsh -s $(which zsh)
  ```

## ¿Cómo usarlo?

Se proporcionan dos funciones:

* `macconfig` abrirá el proyecto con code

## Configuración manual (no puedo automatizar todo)

* Configurar iTerm2 <https://apple.stackexchange.com/questions/136928/using-alt-cmd-right-left-arrow-in-iterm>

## Documentación

Las herramientas de Terraform están documentadas en [terraform-family.md](docs/terraform-family.md).

## Varios

### Conferencia

- Hablé sobre este proyecto en DevFest Strasbourg 2023: <https://www.youtube.com/watch?v=3EVxJo2A5a8>

### ¿Puedo usarlo?

Úsalo bajo tu propio riesgo. Este playbook no está destinado a ser utilizado por otras personas, solo es para compartir cómo provisiono mis computadoras.

### mise: instalar herramientas

  ```shell
  mise install
  ```

### Renovar claves GPG

- Para renovar las claves GPG, usa este script:
  ```shell
  gpg-generate-key.sh
  ```

Para más comandos de GPG, consulta [gpg-cheatsheet.md](roles/mac_dev_playbook/files/HOME/gpg-cheatsheet.md).

### Comprender la firma de commits con GPG

- Consulta el excelente artículo aquí de https://github.com/Thomgrus: https://www.sfeir.dev/securite/securite-signer-ses-commits/

- Consulta https://www.jetbrains.com/help/idea/set-up-GPG-commit-signing.html#enable-commit-signing para configurar las claves GPG.

### Cargar clave SSH en ssh-agent

- Consulta https://apple.stackexchange.com/a/250572/222951

### Configurar plantilla de mensajes de commit

- Consulta https://efren45marin.medium.com/how-to-take-your-git-commit-messages-to-the-next-level-with-a-commit-template-cd3a608b1ac9
