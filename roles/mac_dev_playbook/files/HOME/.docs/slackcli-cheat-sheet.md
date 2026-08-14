# SlackCLI
> shaharia-lab/slackcli — non officiel

## Conversations & messages
```sh
slackcli conversations list --types=public_channel
slackcli conversations read C1234567890                            # derniers messages
slackcli conversations read C123… --thread-ts=… --limit=50         # thread précis
slackcli messages send --recipient-id=C123… --message="Hello"      # canal ou DM (U…)
slackcli messages react --channel-id=C123… --timestamp=… --emoji=+1
```

Le `thread-ts` n'est pas le `p…` de l'URL Slack : retirer le `p` puis remettre le
point avant les 6 derniers chiffres (microsecondes).
`.../p1786346360204879` → `--thread-ts=1786346360.204879`

## Alias
```sh
alias sl='slackcli'
alias slch='slackcli conversations list --types=public_channel'
alias slread='slackcli conversations read'
alias slsend='slackcli messages send'

slmsg() { slackcli messages send --recipient-id="$1" --message="$2"; }  # slmsg C123… "texte"
slurl "https://…/archives/C08GK8WFT1S/p1786346360204879"  # lit une conversation depuis un lien Slack
```
