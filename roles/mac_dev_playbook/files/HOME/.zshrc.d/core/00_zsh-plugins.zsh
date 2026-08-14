#!/usr/bin/env zsh

# zsh-completions + Homebrew formula completions: extend fpath before oh-my-zsh
# runs compinit (01_oh-my-zsh-plugins.zsh), so formulae's static _<tool> files
# (gh, git, mise, starship, copilot, k9s, atuin...) get picked up without
# each of them needing its own `source <(tool completion zsh)` line.
# ~/.zsh-completions holds vendored completions for tools with no Homebrew
# formula (e.g. gita, installed via mise's pipx backend).
fpath=("$(brew --prefix)/share/zsh-completions" "$(brew --prefix)/share/zsh/site-functions" "$HOME/.zsh-completions" $fpath)

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
