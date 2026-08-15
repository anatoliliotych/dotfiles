# dotfiles

Nix-managed macOS setup: nix-darwin (system) + home-manager (user) + nixvim (nvim), one flake at the repo root.

## Bootstrap (new machine)

1. Install Xcode Command Line Tools and the Determinate nix installer:
   ```
   curl https://install.determinate.systems/nix | sh -s -- install
   ```
2. Enroll Touch ID, install 1Password and sign in with CLI integration enabled.
3. Clone this repo anywhere, then set the `user` variable in `flake.nix` to the local account name.
4. Register the flake for default discovery, so bare `sudo darwin-rebuild
   switch` resolves it (darwin-rebuild looks for /etc/nix-darwin/flake.nix
   and uses the machine hostname as the configuration attribute):
   ```
   sudo mkdir -p /etc/nix-darwin
   sudo ln -s ~/dotfiles/flake.nix /etc/nix-darwin/flake.nix
   ```
5. Activate everything - one time only:
   ```
   nix run "github:LnL7/nix-darwin/nix-darwin-26.05#darwin-rebuild" -- switch --flake ~/dotfiles#stardusty
   ```

The bootstrap command follows the nix-darwin release branch and never needs
updating; the system it activates is fully pinned by `flake.lock`.

## Everyday

```
sudo darwin-rebuild switch
```

applies system + home-manager changes; no flake flag needed (it is discovered
via /etc/nix-darwin/flake.nix, and the configuration is named after the
machine hostname). To bump versions, run `nix flake update` in the repo root
first.

The whole repo is flake source, so edits to tracked files (`.nix` configs and
root dotfiles alike) are picked up from the working tree on the next switch.
Untracked files are invisible to nix until `git add`ed; commit new dotfiles
before deploying them.

Format with `nix fmt -- flake.nix nix/*.nix` (nixfmt; nix 2.25 forwards only
the given file args to the formatter, so the paths must be explicit).

## What lives where

- `flake.nix` - inputs (nixpkgs, home-manager, nixvim, nix-darwin) and the "stardusty" configuration (named after the machine hostname)
- `nix/home.nix` - packages, zsh, git, bat, fzf, launchd agents, dotfile links
- `nix/nvim.nix` - the entire nvim configuration (nixvim)
- `nix/darwin.nix` - system config: Touch ID sudo, weekly store maintenance
- `nix/opensuperwhisper.nix` - OpenSuperWhisper.app package
- `nix/mole.nix` - mole CLI package (tw93/mole, source-built; bump the version + hashes to update)
- `configs/` - dotfiles (`.tmux.conf`, `.aerospace.toml`, `.wezterm.lua`, `onehalfdark.zsh-theme`) linked into `~` via home-manager

Note: the nix daemon and `/etc/nix/nix.conf` are managed by the Determinate
installer, not nix-darwin; store gc/optimise run as plain launchd daemons
(Sundays 02:30 / 03:00).
