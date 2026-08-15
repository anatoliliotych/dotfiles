# dotfiles

Nix-managed macOS setup: nix-darwin (system) + home-manager (user) + nixvim (nvim), one flake.

## Bootstrap (new machine)

1. Install Xcode Command Line Tools and the Determinate nix installer:
   ```
   curl https://install.determinate.systems/nix | sh -s -- install
   ```
2. Enroll Touch ID, install 1Password and sign in with CLI integration enabled.
3. Clone this repo to `~/dotfiles` (the flake expects this path and user `al`).
4. Register the flake for default discovery, so bare `sudo darwin-rebuild
   switch` resolves it (darwin-rebuild looks for /etc/nix-darwin/flake.nix
   and uses the machine hostname as the configuration attribute):
   ```
   sudo mkdir -p /etc/nix-darwin
   sudo ln -s ~/dotfiles/home-manager/flake.nix /etc/nix-darwin/flake.nix
   ```
5. Activate everything - one time only:
   ```
   nix run "github:LnL7/nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ~/dotfiles/home-manager#stardusty
   ```

The bootstrap command follows the nix-darwin release branch and never needs
updating; the system it activates is fully pinned by `home-manager/flake.lock`.

## Everyday

```
sudo darwin-rebuild switch
```

applies system + home-manager changes; no flake flag needed (it is discovered
via /etc/nix-darwin/flake.nix, and the configuration is named after the
machine hostname). To bump versions, run `nix flake update` in `home-manager/`
first.

## What lives where

- `home-manager/flake.nix` - inputs (nixpkgs, home-manager, nixvim, nix-darwin) and the "stardusty" configuration (named after the machine hostname)
- `home-manager/home.nix` - packages, zsh, git, bat, fzf, launchd agents, dotfile links
- `home-manager/nvim.nix` - the entire nvim configuration (nixvim)
- `home-manager/darwin.nix` - system config: Touch ID sudo, weekly store maintenance
- `home-manager/opensuperwhisper.nix` - OpenSuperWhisper.app package
- `home-manager/mole.nix` - mole CLI package (tw93/mole, source-built; bump the version + hashes to update)

Note: the nix daemon and `/etc/nix/nix.conf` are managed by the Determinate
installer, not nix-darwin; store gc/optimise run as plain launchd daemons
(Sundays 02:30 / 03:00).
