#!/usr/bin/env zsh

# Linuxbrew's bin isn't on PATH by default (unlike macOS, where the Homebrew
# installer adds this to ~/.zprofile itself). Must run before any fragment
# that calls brew (e.g. 00_zsh-plugins.zsh).
if [[ "$(uname)" == "Linux" && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
