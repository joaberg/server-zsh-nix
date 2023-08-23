{ config, pkgs, ... }:
# https://rycee.gitlab.io/home-manager/options.html


with pkgs.lib; {
    
    home.packages = with pkgs; [
        zsh # dependency of enhancd
        fzf # dependency of enhancd
        peco # dependency of enhancd
        zf # dependency of enhancd
        meslo-lgs-nf # Nerdfont for p10k theme 
       	git # Needed by zsh / zplug
        nitch # a faster neofetch alternative
        lsd # ls deluxe
        micro # editor
        neovim # editor
        tldr  # short  man /help

    ];

    # Will make the font cache update when needed.
	fonts.fontconfig.enable = true;

    # installs autojump, ie use "j dir" to go to a dir you have visited earlier
    programs.autojump = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        
        #enableCompletion = true;

        shellAliases = {
            ll = "lsd -la";	
	    l = "lsd";
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
            { name = "b4b4r07/enhancd"; }
            { name = "chisui/zsh-nix-shell"; } # Makes the nix-shell command be zsh instead of bash.
            { name = "zsh-users/zsh-syntax-highlighting"; }
            { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
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
}
