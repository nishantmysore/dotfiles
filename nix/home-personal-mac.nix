{ pkgs, ... }:

{
  imports = [ ./home-darwin.nix ];

  # Personal Mac-only packages go here.
  home.packages = with pkgs; [
  ];

  programs.fish.shellAliases.rebuild = "sudo nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --flake ~/Documents/dotfiles/nix#personal-mac";
}
