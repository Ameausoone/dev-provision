# SlackCLI
> shaharia-lab/slackcli — non officiel

## Install
```sh
brew tap shaharia-lab/tap
brew install slackcli
brew upgrade slackcli
```

## Conversations
```sh
slackcli conversations list                                        # toutes les conversations
slackcli conversations list --types=public_channel                 # filtre : public_channel, im, …
slackcli conversations read C1234567890                            # derniers messages
slackcli conversations read C123… --thread-ts=… --limit=50         # thread précis, limite
slackcli conversations read C123… --json                           # sortie structurée
```

Le `thread-ts` n'est pas le `p…` de l'URL Slack : retirer le `p` puis remettre le
point avant les 6 derniers chiffres (microsecondes).
`.../p1786346360204879` → `--thread-ts=1786346360.204879`

## Messages
```sh
slackcli messages send --recipient-id=C123… --message="Hello"      # canal ou DM (U…)
slackcli messages send --recipient-id=C123… --thread-ts=… --message="…"  # réponse en thread
slackcli messages send --recipient-id=C123… --message="…" --file=./report.pdf  # avec pièce jointe
slackcli messages edit --channel-id=C123… --timestamp=… --message="…"
slackcli messages react --channel-id=C123… --timestamp=… --emoji=+1
```

## Canvas
```sh
slackcli canvas list --channel=C123…                                # canvases d'un canal (ou tous si omis)
slackcli canvas read F1234567890                                    # contenu en markdown
slackcli canvas read F123… --json
slackcli canvas read --channel=C123…                                # canvas rattaché au canal
```

## Multi-workspace / update
```sh
slackcli conversations list --workspace=T1234567                   # cible un workspace (ID ou nom)
slackcli update check
slackcli update                                                     # préférer `brew upgrade slackcli`
```

## Alias
```sh
alias sl='slackcli'
alias slch='slackcli conversations list --types=public_channel'
alias sldm='slackcli conversations list --types=im'
alias slread='slackcli conversations read'
alias slsend='slackcli messages send'
alias slcanvas='slackcli canvas list'
alias slup='slackcli update'

slmsg() { slackcli messages send --recipient-id="$1" --message="$2"; }  # slmsg C123… "texte"

slurl "https://…/archives/C08GK8WFT1S/p1786346360204879"  # lit une conversation depuis un lien Slack
```
