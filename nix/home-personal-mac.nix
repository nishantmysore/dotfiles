{ pkgs, lib, ... }:

{
  imports = [ ./home-darwin.nix ];

  home.username = "nishraptor";
  home.homeDirectory = lib.mkForce "/Users/nishraptor";

  # Personal Mac-only packages go here.
  home.packages = with pkgs; [
  ];

  programs.fish.shellAliases.rebuild = "sudo nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --flake ~/nix/nix#personal-mac";
}
