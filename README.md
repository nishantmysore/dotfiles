# Dotfiles

This repo contains Nix-based dotfiles for macOS and Linux.

## macOS setup

The macOS config lives in [`nix/`](./nix).

From this checkout, apply the Darwin configuration with:

```bash
cd /Users/nishant.mysore/Documents/dotfiles/nix
sudo nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --flake .#nishants-air
```

Inside the configured Fish shell, you can also use:

```bash
rebuild
```

That alias points back at this checkout.
