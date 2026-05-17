#!/bin/sh

 if command -v mycommand >/dev/null 2>&1; then
    code --list-extensions | sort > $XDG_CONFIG_HOME/Code/User/extensions.txt
fi

