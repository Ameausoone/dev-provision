#!/usr/bin/env zsh

# kubectx's Homebrew formula ships static _kubectx/_kubens zsh completion
# files, picked up automatically via the fpath set in 00_zsh-plugins.zsh --
# only the aliases need wiring here.
alias kx=kubectx
compdef kx=kubectx
alias kn=kubens
compdef kn=kubens

# Chain a context switch + namespace switch in one call, e.g.
# `kcn my-context my-ns`, with tab-completion on both arguments (first arg
# completes contexts via _kubectx, second completes namespaces via _kubens).
kcn() {
  kubectx "$1" && kubens "$2"
}
compdef '_arguments "1:context:_kubectx" "2:namespace:_kubens"' kcn
