# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

An Ansible playbook that provisions a developer machine, on both macOS and Ubuntu. It installs
Homebrew packages (Linuxbrew on Ubuntu), copies dotfiles to `$HOME`, configures zsh with
oh-my-zsh, sets up GitHub CLI extensions, and on Ubuntu also installs apt packages and
Flatpak (Flathub) apps for the GUI tools that only exist as macOS casks.

## Running the playbook

```bash
ansible-playbook main.yml --diff --verbose --inventory ~/.inventory --limit $(hostname)
```

Run only brew tasks:

```bash
ansible-playbook main.yml --tags brew
```

Run only dotfile tasks:

```bash
ansible-playbook main.yml --tags dotfiles
```

Run only Ubuntu apt/flatpak tasks (no-op on macOS):

```bash
ansible-playbook main.yml --tags apt,flatpak --ask-become-pass
```

## Git workflow

This is a solo personal repo — push commits directly to `main`, no feature branch/PR needed.

## Mise tasks

```bash
# Install tools defined in mise.toml
mise install

# Compare provisioned dotfiles against actual $HOME
mise run compare-dotfiles
```

## Architecture

- `main.yml` — entry point, delegates to `roles/mac_dev_playbook`
- `roles/mac_dev_playbook/tasks/main.yml` — task orchestration (oh-my-zsh → dotfiles → brew → apt/flatpak[Ubuntu only] → docker → github → shells → osx[macOS only])
- `roles/mac_dev_playbook/tasks/apt.yml` / `flatpak.yml` — Ubuntu-only, imported when `ansible_facts.os_family == 'Debian'`
- `roles/mac_dev_playbook/defaults/main.yml` — all package lists (Homebrew taps, common vs `*_darwin_only` packages, apt packages/repos, flatpak packages, npm packages, gh CLI extensions)
- `roles/mac_dev_playbook/files/HOME/` — dotfiles copied recursively to `$HOME` on each playbook run
- `roles/mac_dev_playbook/files/HOME/.zshrc.d/` — zsh config fragments, sourced alphabetically by `~/.zshrc`; several fragments branch on `uname` to skip macOS-only setup (coreutils PATH shim, IntelliJ launcher, oh-my-zsh `iterm2`/`macos` plugins)
- `roles/mac_dev_playbook/files/HOME/.docs/` — per-tool cheat sheets (`<tool>-cheat-sheet.md`), deployed to `~/.docs/`
- `roles/mac_dev_playbook/files/dotfiles/ghostty/` — OS-specific Ghostty configs (`config.darwin`, `config.linux`), placed by `dotfiles.yml` at the right XDG/macOS path
- `roles/mac_dev_playbook/files/HOME/.gitconfig` — includes `~/.gitconfig.local` (untracked, machine-local overrides only — never repo-managed), `~/.gitconfig.os` (OS-specific, see `dotfiles/gitconfig-os/`), and `~/.gitconfig.priv` (content-free hook for the private companion repo to attach to — see its own CLAUDE.md)
- `scripts/compare-dotfiles.sh` — diffs provisioned files against the live `$HOME`
- `docs/` — articles and cheatsheets (mise, MCP, etc.)

## Key conventions

- Add/remove packages in `roles/mac_dev_playbook/defaults/main.yml` (not in task files). Cross-platform
  formulae go in `mac_dev_playbook_homebrew_installed_packages_common`; macOS-only ones in
  `*_darwin_only`; Ubuntu-only GUI apps go in `mac_dev_playbook_apt_packages`,
  `mac_dev_playbook_apt_repo_packages` (apt packages needing their own repo/GPG key), or
  `mac_dev_playbook_flatpak_packages`.
- `mac_dev_playbook_apt_repo_packages` also covers Launchpad PPAs (e.g. `ghostty` via
  `ppa:mkasberg/ghostty-ubuntu`): use `uris: https://ppa.launchpadcontent.net/<user>/<ppa>/ubuntu/`,
  `suites: "{{ ansible_facts.distribution_release }}"`, and `signed_by` pointing at an HTTPS
  keyserver lookup (`https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x<fingerprint>`)
  — not `ansible.builtin.apt_repository`'s `ppa:` shorthand, which is deprecated and fetches the key
  over the legacy `hkp://` protocol (unreliable/often filtered). Get the fingerprint once from a
  failed `apt_repository` attempt's error output, or from the PPA's Launchpad page.
- Dotfiles go under `roles/mac_dev_playbook/files/HOME/` mirroring the `$HOME` structure
- New cheat sheets go under `.docs/` as `<tool>-cheat-sheet.md`, terse `## Section` + fenced code
  block style (see `git-cheat-sheet.md`)
- zsh scripts in `.zshrc.d/` are loaded alphabetically — use numeric prefixes (`00_`, `01_`) to control order
- When adding a new CLI tool, check whether it needs shell completion configured. Homebrew-installed
  tools that ship a static `_<tool>` file (gh, git, mise, starship, copilot, k9s, atuin, ...)
  are picked up automatically via the `fpath` set in `00_zsh-plugins.zsh` — no extra work needed.
  Tools installed another way (mise, apt, apt-repo, manual binary) or whose formula doesn't ship a
  static completion (e.g. awscli) need their own `.zshrc.d/core/50_<tool>.zsh` fragment, typically
  `source <(<tool> completion zsh)` (see `50_kubectl.zsh`, `50_acli.zsh`) — check the tool's own docs
  for the exact subcommand/flag first.
- Ansible collections required: `community.general`, `ansible.posix` (install via `ansible-galaxy collection install -r requirements.yml`)
- On Ubuntu, run with `--ask-become-pass` — the apt/flatpak/chsh tasks need sudo. Every privileged
  Ubuntu task must have `become: true` explicitly — one that's missing it hits its own separate auth
  prompt instead of Ansible's sudo (PAM for a bare `chsh`, a graphical polkit dialog for
  `community.general.flatpak`, which defaults to system-wide installs). If sudo itself hangs/times
  out (e.g. PAM fingerprint auth configured on the machine), that needs a `NOPASSWD` sudoers rule for
  the user — a rule scoped to specific commands isn't practically achievable, since Ansible's
  `become` wraps every module in a dynamically-named Python temp script under sudo, not a stable
  binary path.
