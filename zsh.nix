{ config, pkgs, ... }:
# https://rycee.gitlab.io/home-manager/options.html


with pkgs.lib; {
    
    home.packages = with pkgs; [
        fzf # dependency of enhancd
        peco # dependency of enhancd
        zf # dependency of enhancd
       	git # Needed by zsh / zplug
        meslo-lgs-nf # Nerdfont  
        iosevka # Font
	htop
	btop
        nitch # a faster neofetch alternative
        lsd # ls deluxe
        tldr  # short  man /help
        helix # Modern vim / neovim, hx command
        du-dust # Disk usage tool, dust command
        fd # Find tool
        ripgrep # grep tool, rg command
	walk # ls/cd navigation tool
	ranger # filemanager
        bat # Better cat
        (nerdfonts.override {
          fonts = [
            "Iosevka"
            "JetBrainsMono"
            "IBMPlexMono"
            "Mononoki"
            "Monofur"
          ];
        })
    ];

    # Will make the font cache update when needed.
	fonts.fontconfig.enable = true;

    # installs autojump, ie use "j dir" to go to a dir you have visited earlier
    programs.autojump = {
        enable = true;
        enableZshIntegration = true;
    };

###
# Micro (editor)
###
    programs.micro = {
      enable = true;
      settings = {
        clipboard = "terminal";
        #clipboard = "external";
        colorscheme = "dracula-tc";
        keymenu = true;
	xterm = true;
      };
    };


###
# Starship prompt
###
programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableIonIntegration = false;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = ''
          [](blue)[ ](bg:blue fg:black)$username$hostname[](bg:purple fg:blue)$directory[](purple) 
          $character
      '';

      username = {
        show_always = true;
        style_user = "bg:blue fg:black";
        style_root = "bg:blue fg:red";
        format = "[$user]($style)";
      };
      directory = {
        format = "[$path]($style)";
        style = "bg:purple fg:black";
        truncate_to_repo = false;
      };
    hostname = {      
      ssh_only = true;
      format = "[🌏](bg:blue fg:black)[$hostname](bg:blue fg:black)";
      disabled = false;
    };
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };
      directory.substitutions = {
        "Documents" = "📄 ";
        "Downloads" = "📥 ";
        "Music" = "🎜 ";
        "Pictures" = "📷 ";
      };

    };

};


###
# ZSH
###
    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        
        #enableCompletion = true;

        shellAliases = {
            ll = "lsd -latr";
            l = "lsd";
            lk = "{cd \$(walk --icons \$@)}";
            x = "exit";
            m = "micro";
            du = "dust";
            cat = "bat";
            home-manager-update = "nix-channel --update && home-manager switch";
            home-manager-cleanup = "nix-collect-garbage &&  home-manager expire-generations \"-3 days\"";
            sudonix = "sudo env \"PATH=$PATH\""; # A workaround for preserving the users PATH during sudo, and gives access to programs installed via nix.
            snippet-nix-install-zsh = "curl -H \"Cache-Control: no-cache\" -sSL https://raw.githubusercontent.com/joaberg/server-zsh-nix/main/install.sh | bash";
            snippet-nix-update-zsh = "curl -H \"Cache-Control: no-cache\" -sSL https://raw.githubusercontent.com/joaberg/server-zsh-nix/main/update.sh | bash";
            snippet-sshkey = "[ -d .ssh ] || ssh-keygen -q -t ed25519 -a 32 -f ~/.ssh/id_ed25519 -P \"\"; grep -q \"AAAAC3NzaC1lZDI1NTE5AAAAINp6BOKX6XDOSLye9Vc2y4wbovNtvqFKas73TKgCOqIQ\" ~/.ssh/authorized_keys || echo \"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINp6BOKX6XDOSLye9Vc2y4wbovNtvqFKas73TKgCOqIQ joakim\" >> ~/.ssh/authorized_keys";
         };



        history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
        };

        zplug = {
            enable = true;
            plugins = [
                # List fo plugins: https://github.com/unixorn/awesome-zsh-plugins
           # { name = "b4b4r07/enhancd"; } # got some buggy behavior on some servers.
            { name = "chisui/zsh-nix-shell"; } # Makes the nix-shell command be zsh instead of bash.
            { name = "zsh-users/zsh-syntax-highlighting"; }
            { name = "dracula/zsh"; tags = [ as:theme depth:1 ]; } 
            ];
        };

        initExtra = ''
         
            # Launch neofetch
            nitch
	    echo "## Use zellij for terminal multiplexer ## Check 'alias' , defined in .config/home-manager/zsh.nix ##"
	    echo "Update to latest zsh.nix: curl -H "Cache-Control: no-cache" -sSL https://raw.githubusercontent.com/joaberg/server-zsh-nix/main/update.sh | bash
"
            '';
           
    };

    # This is a workaround. By default most systems launch bash. This will make zsh start when bash is launched. Usefull if you dont have root access.
    programs.bash.enable = true;
    programs.bash.initExtra = ''
         $HOME/.nix-profile/bin/zsh
    '';

###
# SKIM
###

    programs.skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'lsd --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };    
    
###
# Zoxide
###
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };


###
# Zellij terminal multiplexer
###

 programs.zellij = {
        enable = true;
        #enableZshIntegration = true;
        settings = {
          theme = "dracula";
          scrollback_editor = ".nix-profile/bin/micro";
          default_shell = ".nix-profile/bin/zsh";
          #copy_clipboard = "primary";        
        };
};


}
