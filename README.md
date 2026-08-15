# dotfiles

Nix-managed macOS setup: nix-darwin (system) + home-manager (user) + nixvim (nvim), one flake.

## Bootstrap (new machine)

1. Install Xcode Command Line Tools and the Determinate nix installer:
   ```
   curl https://install.determinate.systems/nix | sh -s -- install
   ```
2. Enroll Touch ID, install 1Password and sign in with CLI integration enabled.
3. Clone this repo to `~/dotfiles` (the flake expects this path and user `al`).
4. Activate everything - one time only:
   ```
   nix run "github:LnL7/nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ~/dotfiles/home-manager#al
   ```

The bootstrap command follows the nix-darwin release branch and never needs
updating; the system it activates is fully pinned by `home-manager/flake.lock`.

## Everyday

```
darwin-rebuild switch
```

applies system + home-manager changes. To bump versions, run
`nix flake update` in `home-manager/` first.

## What lives where

- `home-manager/flake.nix` - inputs (nixpkgs, home-manager, nixvim, nix-darwin) and the "al" configuration
- `home-manager/home.nix` - packages, zsh, git, bat, fzf, launchd agents, dotfile links
- `home-manager/nvim.nix` - the entire nvim configuration (nixvim)
- `home-manager/darwin.nix` - system config: Touch ID sudo, weekly store maintenance
- `home-manager/opensuperwhisper.nix` - OpenSuperWhisper.app package

Note: the nix daemon and `/etc/nix/nix.conf` are managed by the Determinate
installer, not nix-darwin; store gc/optimise run as plain launchd daemons
(Sundays 02:30 / 03:00).
