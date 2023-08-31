#!/bin/bash


#Download the latest zsh.nix
curl -o ~/.config/home-manager/zsh.nix https://raw.githubusercontent.com/joaberg/server-zsh-nix/main/zsh.nix

# Rebuild
home-manager switch -b backup
