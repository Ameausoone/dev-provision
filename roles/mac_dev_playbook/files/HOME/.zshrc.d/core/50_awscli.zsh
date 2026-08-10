#!/usr/bin/env zsh

# awscli doesn't ship a static zsh _aws file; it uses bash's programmable
# completion via aws_completer, so bashcompinit is needed to bridge it.
autoload -Uz bashcompinit && bashcompinit
complete -C aws_completer aws
