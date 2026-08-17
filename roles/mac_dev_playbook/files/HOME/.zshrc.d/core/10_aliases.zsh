#!/usr/bin/env zsh

# ==============================================================================
# Configuration
# ==============================================================================

MACOS_SETUP_DIR=~/projects/perso/provision

# ==============================================================================
# Directory Operations
# ==============================================================================

function mkcd() { mkdir -p "$@" && cd "$_"; }

alias cd..="cd .."
alias ..="cd .."
alias ls="ls -a"

# ==============================================================================
# Git Workflow
# ==============================================================================

function lazy-git() {
  if [[ -z "$1" ]]; then
    echo "Error: commit message required"
    return 1
  fi

  git add . && \
  (git commit -q -a -m "$1" || (git add . && git commit -q -a -m "$1")) && \
  git push -q
}

# The `dp` namespace (provision/push/edit/upgrade) lives in 50_dp.zsh.

# ==============================================================================
# Development Helpers
# ==============================================================================

alias notes="idea ${MACOS_SETUP_DIR}/notes"

# ==============================================================================
# Cheat Sheets
# ==============================================================================

function cheat() {
  local sheets=(~/.docs/*-cheat-sheet.md(N))

  if [[ $# -eq 0 ]]; then
    print "available cheat sheets:"
    for f in $sheets; do
      print "  $(basename $f -cheat-sheet.md)"
    done
    return
  fi

  local found=0
  for pattern in "$@"; do
    for f in $sheets; do
      if [[ $(basename $f) == *$pattern* ]]; then
        bat --style=plain "$f"
        found=1
      fi
    done
  done

  [[ $found -eq 0 ]] && print "no cheat sheet matching '$*'" >&2
}

function _cheat() {
  local -a sheets
  sheets=(~/.docs/*-cheat-sheet.md(N))
  sheets=(${sheets:t:s/-cheat-sheet.md//})
  compadd $sheets
}
compdef _cheat cheat

alias gitmess="cat ~/.gitmessage"
alias zshshorcut="open http://www.geekmind.net/2011/01/shortcuts-to-improve-your-bash-zsh.html"
alias good-readme="open https://github.com/othneildrew/Best-README-Template"

# ==============================================================================
# Tool Aliases
# ==============================================================================

alias diff="grc diff"
alias yaml="highlight --force --syntax yaml"
