# Tmux

Prefix key: `Ctrl-b` (default), shown as `PREFIX` below.

## Sessions
```sh
tmux new -s <name>                         # create named session
tmux ls                                    # list sessions
tmux attach -t <name>                      # attach to session
tmux kill-session -t <name>                # kill session
```
```
PREFIX d        detach
PREFIX $        rename session
PREFIX s        list/switch sessions
PREFIX (  )     previous/next session
```

## Windows
```
PREFIX c        create window
PREFIX ,        rename window
PREFIX &        kill window
PREFIX 0-9      switch to window number
PREFIX n  p     next/previous window
PREFIX w        list windows
```

## Panes
```
PREFIX %        split vertically
PREFIX "        split horizontally
PREFIX o        cycle panes
PREFIX <arrow>  move to pane in direction
PREFIX z        zoom/unzoom pane
PREFIX x        kill pane
PREFIX space    cycle pane layouts
```

## Copy mode
```
PREFIX [        enter copy mode
space           start selection (vi keys)
enter           copy selection
PREFIX ]        paste
```

## Misc
```
PREFIX ?        list all keybindings
PREFIX :        command prompt (e.g. :kill-server)
PREFIX r        reload config (if bound in .tmux.conf)
```
