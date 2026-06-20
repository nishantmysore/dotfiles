{ pkgs, lib, ... }:

{
  imports = [ ./home-common.nix ];

  home.username = "nishant";
  home.homeDirectory = "/home/nishant";

  # Linux-specific shell config
  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake ~/nix#server";
}
