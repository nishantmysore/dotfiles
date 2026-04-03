{ pkgs, lib, ... }:

{
  imports = [ ./home-common.nix ];

  home.username = "nishant";
  home.homeDirectory = "/home/nishant";

  home.packages = with pkgs; [
    home-manager
  ];

  # Linux-specific shell config
  programs.fish.shellAliases.rebuild = "home-manager switch --flake ~/nix#nishant@nishraptorserver";
}
