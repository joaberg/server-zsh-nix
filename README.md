# Server-zsh-nix
Quick way to deploy my zsh on different servers, using nix and home-manager.

It installs Nix with the Determinate installer.

Sets up home-manager and adds the zsh.nix file in .config/home-manager/

Zsh.nix can be modified as you like, just run "home-manager switch" for the changes to take effect.

It also adds "zsh" to the end of .bashrc, as a way to launch zsh at login, without needing root permissions to change the default shell.


Install it from terminal:
```
curl -H "Cache-Control: no-cache" -sSL https://raw.githubusercontent.com/joaberg/server-zsh-nix/main/install.sh | bash
```
After install, run bash or zsh to enter a new shell. It will start setting up the new shell.
Run zsh again to enjoy your awsome new shell.


