{ pkgs, lib, ... }:

{
  imports = [ ./home-darwin.nix ];

  home.username = "nishant.mysore";
  home.homeDirectory = lib.mkForce "/Users/nishant.mysore";

  # Work laptop-only packages go here.
  home.packages = with pkgs; [
    (lib.lowPrio arm-toolchain-for-embedded)
    gcc-arm-embedded
    segger-jlink
  ];

  programs.fish.shellAliases.rebuild = "sudo nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --flake ~/nix/nix#work-macbook";
}
