#!/bin/bash

# removing all traces of nerd-dictation (almost)! Got to clean up your path yourself :)
echo -e "\nRemoving all traces of steam-dictation from your system:\n"
rm -rfv $HOME/.config/nerd-dictation
rm -rfv $HOME/.local/bin/steam-dictation
rm -rfv $HOME/.local/bin/steam-dict-wrapper
rm -rfv $HOME/.local/share/nerd-dictation
rm -rfv $HOME/.xbindkeysrc
rm -rfv /tmp/steam-dict
echo -e "\nAlmost all traces ... If you don't want $HOME/.local/bin in your path you can remove the line:\n\n    export PATH=\$PATH:\$HOME/.local/bin\n\nFrom the following files:\n\n    $HOME/.bashrc\n    $HOME/.bash_profile\n    $HOME/.profile\n"
