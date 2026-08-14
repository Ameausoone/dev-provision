# Git

## Branch
```sh
git switch -c <branch>                     # create and checkout branch
git push -d <remote> <branch>              # delete remote branch
git branch -d <branch>                     # delete local branch
git fetch --all && git pull --all
```

## Worktree
```sh
git worktree add ../<repo>-<branch> <branch>  # checkout branch in sibling dir
git worktree list
git worktree remove ../myrepo-fix
```

## Reset & rebase
```sh
git reset --hard HEAD                      # discard all staged and unstaged changes
git rebase -i HEAD~3                       # rewrite last 3 commits interactively
git push --force-with-lease origin <branch> # safe force push (fails if remote changed)
```

## Cherry pick & tag
```sh
git cherry-pick <commit-hash>
git tag -a <tag> <commit> -m "msg"
git push origin :refs/tags/<tag>           # delete remote tag
```

## Fzf helpers
```sh
fshow            # git commit browser
fcs              # pick commit sha (usage: git rebase -i `fcs`)
```

## Commit types
```
feat      new feature
fix       bug fix
docs      documentation only
refactor  code restructure, no behavior change
chore     maintenance, tooling
```
