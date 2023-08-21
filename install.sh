#!/bin/bash

# Install nix and home-manager
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

if [ $? -eq 0 ]; then # only run if previous command is a succuess.
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh 
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update && nix-shell '<home-manager>' -A install
fi


if [ $? -eq 0 ]; then # only run if previous command is a succuess.
    # Add import of the zsh.nix
    config_file=".config/home-manager/home.nix"
    line_number=$(grep -n "home.stateVersion" "$config_file" | cut -d: -f1)
    text_to_add="imports = [./zsh.nix];"
    
    if [ -n "$line_number" ]; then
        # Check if the text already exists in the file
        if ! grep -qF "$text_to_add" "$config_file"; then
            # Add the text after the specified line number
            sed -i "$((line_number + 1))i\\$text_to_add" "$config_file"
        fi
    fi
    #Download the zsh.nix
    curl -o ~/.config/home-manager/zsh.nix https://raw.githubusercontent.com/joaberg/server-zsh-nix/main/zsh.nix

fi

if [ $? -eq 0 ]; then # only run if previous command is a succuess.
    home-manager switch -b backup
fi

