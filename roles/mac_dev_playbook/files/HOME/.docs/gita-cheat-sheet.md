# gita
> Gère plusieurs repos git à la fois

## Essentiel
```sh
gita add -r ~/code                       # register repos recursively
gita ll                                  # status of all repos
gita fetch / gita pull                   # on all repos
gita super checkout main                 # arbitrary git command on all repos
gita shell ll                            # arbitrary shell command on all repos
gita group add repo1 repo2 -n mygroup    # group repos
gita ll mygroup                          # status of a group
```
