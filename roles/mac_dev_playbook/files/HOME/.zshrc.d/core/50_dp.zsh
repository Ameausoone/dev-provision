#!/usr/bin/env zsh

# dp — provision this machine from the dev-provision playbooks.
#
# Verbs live in the _dp_help registry and are resolved dynamically, so another
# fragment can add one without editing this file (see ~/.zshrc.d/work/55_dp.zsh).
# Same for repositories: _dp_repos maps a key to a checkout, and every key
# automatically becomes a `--<key>` flag on `provision` and `push`.

typeset -gA _dp_help
_dp_help[provision]='run the playbook on this machine'
_dp_help[push]='commit, push, then provision'
_dp_help[edit]='open the repo, or delegate a request to Copilot'
_dp_help[upgrade]='upgrade brew and mise packages'

typeset -gA _dp_repos
_dp_repos[main]="${MACOS_SETUP_DIR}/dev-provision"

# ------------------------------------------------------------------------------
# Internals -- double underscore keeps them out of the verb namespace
# ------------------------------------------------------------------------------

# Splits argv into repo selection (--all, --<key>) and the remaining arguments,
# exposed as _dp_targets / _dp_args. Defaults to the main repo.
typeset -ga _dp_targets _dp_args
__dp_select_repos() {
  _dp_targets=()
  _dp_args=()

  while (( $# )); do
    case "$1" in
      --all) _dp_targets=( ${(@ok)_dp_repos} ) ;;
      --*)
        local key="${1#--}"
        if [[ -n "${_dp_repos[$key]}" ]]; then
          _dp_targets+=( "$key" )
        else
          print -u2 "dp: unknown repo '$1' (known: ${(j:, :)${(@ok)_dp_repos}})"
          return 2
        fi
        ;;
      *) _dp_args+=( "$1" ) ;;
    esac
    shift
  done

  (( ${#_dp_targets} )) || _dp_targets=( main )
}

# Generate a conventional commit message from the staged diff. Must run with the
# target repo as cwd.
__dp_commit_msg() {
  git diff --cached | copilot --silent --model 'claude-haiku-4.5' --prompt \
    "Output exactly one conventional commit message for this staged diff.
Format: <type>(<scope>): <description>
Allowed types: feat, fix, chore, refactor, docs, style, test, ci.
No explanation, no preamble, no quotes, no markdown. One line only." \
    | grep -oE '^(feat|fix|chore|refactor|docs|style|test|ci)(\([^)]+\))?: .+'
}

# Runs ansible-galaxy (only when requirements.yml changed) then the playbook.
# Must run with the target repo as cwd.
__dp_run_playbook() {
  local cache_dir="${HOME}/.cache/dev-provision"
  mkdir -p "${cache_dir}"
  local cache_file="${cache_dir}/requirements-$(basename "$PWD").yml"

  if [[ -f requirements.yml ]] && ! cmp -s requirements.yml "${cache_file}" 2>/dev/null; then
    ansible-galaxy install -r requirements.yml || return 1
    cp requirements.yml "${cache_file}"
  fi

  ansible-playbook main.yml --diff --limit "$(hostname)"
}

__dp_push_one() {
  local key="$1" msg="$2"
  local dir="${_dp_repos[$key]}"

  if [[ ! -d "$dir" ]]; then
    print -u2 "dp push: ${key}: ${dir} not found"
    return 1
  fi

  (
    cd "$dir" || exit 1

    git add .
    if git diff --cached --quiet; then
      print "dp push: ${key}: nothing to commit, skipping."
      exit 0
    fi

    if [[ -z "$msg" ]]; then
      msg=$(__dp_commit_msg)
      if [[ -z "$msg" ]]; then
        print -u2 "dp push: ${key}: could not generate a commit message"
        print -u2 "dp push: run 'copilot' once to check it is available"
        exit 1
      fi
      print "dp push: ${key}: commit message from Copilot: [${msg}]"
    fi

    lazy-git "$msg" || exit 1
    __dp_run_playbook
  )
}

# ------------------------------------------------------------------------------
# Verbs
# ------------------------------------------------------------------------------

_dp_provision() {
  __dp_select_repos "$@" || return
  local key rc=0

  for key in "${_dp_targets[@]}"; do
    ( cd "${_dp_repos[$key]}" && __dp_run_playbook ) || rc=1
  done

  return $rc
}

_dp_push() {
  __dp_select_repos "$@" || return
  local key rc=0

  for key in "${_dp_targets[@]}"; do
    __dp_push_one "$key" "${_dp_args[1]}" || rc=1
  done

  return $rc
}

# No argument opens the workspace; a request is delegated to Copilot, then the
# result is pushed and provisioned. Not run in a subshell: it moves the caller.
_dp_edit() {
  if (( $# == 0 )); then
    idea "${MACOS_SETUP_DIR}"
    return
  fi

  local dir="${_dp_repos[main]}"
  if [[ ! -d "$dir" ]]; then
    print -u2 "dp edit: ${dir} not found"
    return 1
  fi

  cd "$dir" || return 1
  copilot "$*" || return $?
  _dp_push
}

_dp_upgrade() { brew upgrade && mise upgrade; }

# ------------------------------------------------------------------------------
# Dispatcher -- the registry is the gate, so __-prefixed internals stay unreachable
# ------------------------------------------------------------------------------

dp() {
  local verb="${1:-}"
  (( $# )) && shift

  if [[ -n "${_dp_help[$verb]}" ]] && (( $+functions[_dp_$verb] )); then
    "_dp_$verb" "$@"
  else
    [[ -n "$verb" ]] && print -u2 "dp: unknown command '$verb'"
    print -u2 "usage: dp <${(j:|:)${(@ok)_dp_help}}> [--all|--<repo>] [message]"
    return 2
  fi
}

_dp() {
  local curcontext="$curcontext" state line v
  local -a cmds repos

  for v in ${(@ok)_dp_help}; do cmds+=( "${v}:${_dp_help[$v]}" ); done
  for v in ${(@ok)_dp_repos}; do repos+=( "--${v}[only the ${v} repo]" ); done

  _arguments -C '1:command:->cmd' '*::arg:->args'

  case "$state" in
    cmd) _describe -t commands 'dp command' cmds ;;
    args)
      case "${line[1]}" in
        provision|push) _arguments '--all[every repo]' $repos ;;
      esac
      ;;
  esac
}
compdef _dp dp

# Muscle-memory shims for the pre-subcommand names. Delete once they stop firing.
alias dp-provision='dp provision'
alias dp-push='dp push'
alias dp-edit='dp edit'
alias dp-upgrade='dp upgrade'
