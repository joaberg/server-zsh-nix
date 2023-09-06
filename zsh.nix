{ config, pkgs, ... }:
# https://rycee.gitlab.io/home-manager/options.html


with pkgs.lib; {
    
    home.packages = with pkgs; [
        fzf # dependency of enhancd
        peco # dependency of enhancd
        zf # dependency of enhancd
        meslo-lgs-nf # Nerdfont for p10k theme 
       	git # Needed by zsh / zplug
	htop
        nitch # a faster neofetch alternative
        lsd # ls deluxe
        #neovim # editor
        tldr  # short  man /help
        helix # Modern vim / neovim, hx command
        du-dust # Disk usage tool, dust command
        fd # Find tool
        ripgrep # grep tool, rg command
	walk # ls/cd navigation tool
	ranger # filemanager
        xclip # Needed by micro ?
        wl-clipboard # Needed by micro ?
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
# ZSH
###
    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        
        #enableCompletion = true;

        shellAliases = {
            ll = "lsd -la";
            l = "lsd";
            walk = "{cd \$(walk \$@)}";
            x = "exit";
            m = "micro";
            du = "dust";
            home-manager-update = "nix-channel --update && home-manager switch";
            sudonix = "sudo env \"PATH=$PATH\""; # A workaround for preserving the users PATH during sudo, and gives access to programs installed via nix.
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
            { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
            { name = "dracula/zsh"; tags = [ as:theme depth:1 ]; } 
            ];
        };

        initExtra = ''
            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
            # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
            

            # Launch neofetch
            nitch
	    echo "### To customize prompt, run 'p10k configure' ## Check 'alias' , defined in .config/home-manager/zsh.nix ##"
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
# TMUX
###
  programs.tmux = {
    enable = true;

    shell = "$HOME/.nix-profile/bin/zsh";

    # Start numbering tabs at 1, not 0
    baseIndex = 1;

    # Automatically spawn a session if trying to attach and none are running
    newSession = true;

    prefix = "C-a";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      yank
      {
        plugin = dracula;
        extraConfig = ''
          # https://draculatheme.com/tmux
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          
          # available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, attached-clients, network-vpn, weather, time, spotify-tui, kubernetes-context, synchronize-panes
          set -g @dracula-plugins "cpu-usage ram-usage network-bandwidth"

          # available colors: white, gray, dark_gray, light_purple, dark_purple, cyan, green, orange, red, pink, yellow
          # set -g @dracula-[plugin-name]-colors "[background] [foreground]"
          set -g @dracula-cpu-usage-colors "pink dark_gray"
          
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
            set -g @continuum-restore 'on'
        '';
      }
    ];

    extraConfig = ''
      set -g mouse on


      # Use shift-left and shift-right to move between tabs
        bind-key -n S-Left prev
        bind-key -n S-Right next

      # Shortcuts to move between split panes, using Control and arrow keys
        bind-key -n C-Down select-pane -D
        bind-key -n C-Up select-pane -U
        bind-key -n C-Left select-pane -L
        bind-key -n C-Right select-pane -R

      # Shortcuts to split the window into multiple panes
      #
      # Mnemonic: the symbol (- or |) looks like the line dividing the
      # two panes after the split.
        bind | split-window -h
        bind - split-window -v

      # Shortcuts to resize the currently-focused pane.
      # You can tap these repeatedly in rapid succession to adjust
      # the size incrementally (the -r flag accomplishes this).
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r H resize-pane -L 5
        bind -r L resize-pane -R 5
      '';

    
  };

}
