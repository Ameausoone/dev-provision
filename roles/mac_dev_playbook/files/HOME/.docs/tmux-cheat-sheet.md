# Tmux

Prefix key: `Ctrl-b` (default), shown as `PREFIX` below.
Config: `~/.tmux.conf` (mouse on, vi copy mode, windows/panes numbered from 1).

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
PREFIX 1-9      switch to window number
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
v               start selection
y               copy selection and exit
PREFIX ]        paste
```

## Misc
```
PREFIX ?        list all keybindings
PREFIX :        command prompt (e.g. :kill-server)
PREFIX r        reload ~/.tmux.conf
```
