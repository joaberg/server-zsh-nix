#!/bin/bash

# Install nix and home-manager
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 
source .baschrc 
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager 
nix-channel --update 
nix-shell '<home-manager>' -A install

# Add import of the zsh.nix
config_file=".config/home-manager/home.nix"; line_number=$(grep -n "home.stateVersion" "$config_file" | cut -d: -f1); text_to_add="imports = [\\
    ./zsh.nix # zsh config\\
];"; if [ -n "$line_number" ]; then sed -i "$((line_number + 1)),$((line_number + 1))i\\$text_to_add\\" "$config_file"; else echo "Line not found in the file."; fi 

#Download the zsh.nix
echo -e '{ config, pkgs, ... }:\n# https://rycee.gitlab.io/home-manager/options.html\n\nwith pkgs.lib; {\n    \n    home.packages = with pkgs; [\n        zsh # dependency of enhancd\n        fzf # dependency of enhancd\n        peco # dependency of enhancd\n        zf # dependency of enhancd\n        nerdfonts \n        git # Needed by zsh / zplug\n        nitch # a faster neofetch alternative\n        lsd # ls deluxe\n        micro # editor\n        neovim # editor\n        tldr  # short  man /help\n\n    ];\n\n    # Will make the font cache update when needed.\n    fonts.fontconfig.enable = true;\n\n    # installs autojump, ie use "j dir" to go to a dir you have visited earlier\n    programs.autojump = {\n        enable = true;\n        enableZshIntegration = true;\n    };\n\n    programs.zsh = {\n        enable = true;\n        enableAutosuggestions = true;\n        #enableCompletion = true;\n        shellAliases = {\n            ll = "lsd -la";\n            home-manager-update = "nix-channel --update && home-manager switch";\n            sudonix = "sudo env \"PATH=$PATH\""; # A workaround for preserving the users PATH during sudo, and gives access to programs installed via nix.\n        };\n        history = {\n            size = 10000;\n            path = "${config.xdg.dataHome}/zsh/history";\n        };\n        zplug = {\n            enable = true;\n            plugins = [\n                # List fo plugins: https://github.com/unixorn/awesome-zsh-plugins\n                { name = "b4b4r07/enhancd";'

home-manager switch

