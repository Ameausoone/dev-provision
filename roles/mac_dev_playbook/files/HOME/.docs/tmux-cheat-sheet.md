# Tmux

Prefix key: `Ctrl-b` (default), shown as `PREFIX` below.

## Sessions
```sh
tmux new -s <name>                         # create named session
tmux ls
tmux attach -t <name>
```
```
PREFIX d        detach
PREFIX s        list/switch sessions
```

## Windows & panes
```
PREFIX c        create window
PREFIX 1-9      switch to window number
PREFIX %        split vertically
PREFIX "        split horizontally
PREFIX o        cycle panes
PREFIX z        zoom/unzoom pane
PREFIX x        kill pane
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
PREFIX r        reload ~/.tmux.conf
```
