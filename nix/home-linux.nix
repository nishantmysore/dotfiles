{ pkgs, lib, ... }:

{
  imports = [ ./home-common.nix ];

  home.username = "nishant";
  home.homeDirectory = "/home/nishant";
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  home.packages = with pkgs; [
    home-manager
    tailscale
  ];

  # Linux-specific shell config
  programs.fish.shellAliases.rebuild = "sudo nixos-rebuild switch --flake ~/nix#nishraptorserver";

}
